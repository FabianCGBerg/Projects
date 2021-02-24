# Importing Packages
import tweepy
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import pandas as pd
import numpy as np
import nltk
import re
import string
from wordcloud import WordCloud, STOPWORDS
from PIL import Image
from sklearn.feature_extraction.text import CountVectorizer


def get_tweets(screen_name, consumer_key, consumer_secret, access_token, access_token_secret, allow_reply,
               allow_retweet):
    # Twitter only allows access to a users most recent 3240 tweets with this method

    # authorize twitter, initialize tweepy
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    api = tweepy.API(auth)

    # initialize a list to hold all the tweepy Tweets
    alltweets = []

    # make initial request for most recent tweets (200 is the maximum allowed count)
    new_tweets = api.user_timeline(screen_name=screen_name, count=200)

    # save most recent tweets
    alltweets.extend(new_tweets)

    # save the id of the oldest tweet less one
    oldest = alltweets[-1].id - 1

    # keep grabbing tweets until there are no tweets left to grab
    while len(new_tweets) > 0:
        print(f"getting tweets before {oldest}")

        # all subsequent requests use the max_id param to prevent duplicates
        new_tweets = api.user_timeline(screen_name=screen_name, count=200, max_id=oldest)

        # save most recent tweets
        alltweets.extend(new_tweets)

        # update the id of the oldest tweet less one
        oldest = alltweets[-1].id - 1

        print(f"...{len(alltweets)} tweets downloaded so far")

    # transform the tweepy tweets into a 2D array that will populate the csv
    outtweets = [[tweet.id_str, tweet.created_at, tweet.text, tweet.in_reply_to_status_id, tweet.retweeted] for tweet in
                 alltweets]

    # Transform to a Dataframe for easier manipulation with Pandas
    df = pd.DataFrame(outtweets)

    # Depending on the setting we might want to remove retweets and replies (leaving only original posts)
    if not allow_reply:
        # If it's a reply the "in_reply" field will have a user ID in it
        # We can use this to only keep the tweets that don't have a reply ID in it
        df = df[np.isnan(df.iloc[:, 3])]

    if not allow_retweet:
        # The "retweeted" field is set to TRUE is it's a retweet, so we can remove those too
        df = df[df.iloc[:, 4] == False]

    df.drop(df.columns[4], axis=1, inplace=True)
    df.drop(df.columns[3], axis=1, inplace=True)

    df.columns = [["id", "created_at", "text"]]
    df.to_csv(screen_name + '_tweets.csv', sep='\t')


def count_values_in_column(data, feature):
    total = data.loc[:, feature].value_counts(dropna=False)
    percentage = round(data.loc[:, feature].value_counts(dropna=False, normalize=True) * 100, 2)
    return pd.concat([total, percentage], axis=1, keys=['Total', 'Percentage'])


def create_pie_chart(data_df, column_name):
    # create data for Pie Chart
    piechart = count_values_in_column(data_df, column_name)
    names = piechart.index
    size = piechart['Percentage']

    # Create a circle for the center of the plot
    my_circle = plt.Circle((0, 0), 0.7, color='white')
    plt.pie(size, labels=names, colors=['green', 'blue', 'red'])
    p = plt.gcf()
    p.gca().add_artist(my_circle)
    plt.show()


# Function to Create Wordcloud
def create_wordcloud(text, name):
    mask = np.array(Image.open('twitter_mask.png'))
    stopwords = set(STOPWORDS)
    wc = WordCloud(background_color='white',
                   mask=mask,
                   max_words=3000,
                   stopwords=stopwords,
                   repeat=True)
    wc.generate(str(text))
    wc.to_file(name + '_wc.png')
    print('Word Cloud Saved Successfully')

    img = mpimg.imread(name + '_wc.png')
    plt.imshow(img)


# Removing Punctuation
def remove_punct(text):
    text = "".join([char for char in text if char not in string.punctuation])
    text = re.sub('[0–9]+', '', text)
    return text


# Applying tokenization
def tokenization(text):
    text = re.split('\W+', text)
    return text


stopword = nltk.corpus.stopwords.words('english')


def remove_stopwords(text):
    text = [word for word in text if word not in stopword]
    return text


ps = nltk.PorterStemmer()


def stemming(text):
    text = [ps.stem(word) for word in text]
    return text


# REGEX text cleaning
def clean_text_expanded(input_df, col):
    remove_rt = lambda x: re.sub('RT @\w+: ', '', x)
    # remove_users = lambda x: re.sub('(@[A-Za-z0–9]+)', '', x)
    remove_users = lambda x: re.sub('@.*?(?=\s)', '', x)
    remove_newline = lambda x: re.sub('\n', '', x)
    remove_links = lambda x: re.sub('https:\/\/.*', '', x)
    remove_emojis = lambda x: re.sub('[^\w\s#@/:%.,_-]', '', x)
    remove_punc = lambda x: re.sub('[^\w\s]', '', x)
    remove_empty = lambda x: re.sub('^\s+$', 'n_a_n', x)
    to_lowercase = lambda x: x.lower() if isinstance(x, str) else x

    # Apply the regex above to the text column
    input_df[col] = input_df.text.map(remove_rt).map(remove_users).map(remove_newline).map(remove_links) \
        .map(remove_emojis).map(remove_empty).map(to_lowercase)

    # Remove the rows with no text
    input_df[col].replace('n_a_n', np.nan, inplace=True)
    input_df.dropna(subset=['text'], inplace=True)

    return input_df


def clean_text_expanded_2(text):
    text = re.sub('RT @\w+: ', '', text)
    # text = re.sub('(@[A-Za-z0–9]+)', '', text)
    text = re.sub('@.*?(?=\s)', '', text)
    text = re.sub('\n', '', text)
    text = re.sub('https:\/\/.*', '', text)
    text = re.sub('[^\w\s#@/:%.,_-]', '', text)
    text = re.sub('[^\w\s]', '', text)
    text = re.sub('^\s+$', 'n_a_n', text)
    text = text.lower()

    return text

# Cleaning Text
def clean_text(text):
    text_lc = "".join([word.lower() for word in text if word not in string.punctuation])  # remove puntuation
    text_rc = re.sub('[0-9]+', '', text_lc)
    tokens = re.split('\W+', text_rc)  # tokenization
    text = [ps.stem(word) for word in tokens if word not in stopword]  # remove stopwords and stemming
    return text


# Function to ngram
def get_top_n_gram(corpus, ngram_range, n=None):
    vec = CountVectorizer(ngram_range=ngram_range, stop_words='english').fit(corpus)
    bag_of_words = vec.transform(corpus)
    sum_words = bag_of_words.sum(axis=0)
    words_freq = [(word, sum_words[0, idx]) for word, idx in vec.vocabulary_.items()]
    words_freq = sorted(words_freq, key=lambda x: x[1], reverse=True)
    return words_freq[:n]
