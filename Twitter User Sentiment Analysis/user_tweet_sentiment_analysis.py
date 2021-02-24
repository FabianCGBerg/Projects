from textblob import TextBlob
import pandas as pd
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from sklearn.feature_extraction.text import CountVectorizer
import sentiment_functions as sf

# Authentication from the Twitter API
consumerKey = '[API Key]'
consumerSecret = '[API Key]'
accessToken = '[API Key]'
accessTokenSecret = '[API Key]'

# Specify the user
user = 'RealFabianBerg'

# Getting recent tweets
sf.get_tweets(user, consumerKey, consumerSecret, accessToken, accessTokenSecret, False, False)

# Loading the tweets
tweet_df = pd.read_csv(user + '_tweets.csv', delimiter='\t')
tweet_df.drop_duplicates(inplace=True)

# Cleaning the data using RegEx
tweet_df = sf.clean_text_expanded(tweet_df, 'text')

tweet_df.drop(['id', 'created_at'], axis=1, inplace=True)

# Calculating Negative, Positive, Neutral and Compound values
tweet_df[['polarity', 'subjectivity']] = tweet_df['text'].apply(lambda text: pd.Series(TextBlob(text).sentiment))

for index, row in tweet_df['text'].iteritems():
    score = SentimentIntensityAnalyzer().polarity_scores(row)
    neg = score['neg']
    neu = score['neu']
    pos = score['pos']
    comp = score['compound']
    if neg > pos:
        tweet_df.loc[index, 'sentiment'] = "negative"
    elif pos > neg:
        tweet_df.loc[index, 'sentiment'] = "positive"
    else:
        tweet_df.loc[index, 'sentiment'] = "neutral"

    tweet_df.loc[index, 'neg'] = neg
    tweet_df.loc[index, 'neu'] = neu
    tweet_df.loc[index, 'pos'] = pos
    tweet_df.loc[index, 'compound'] = comp

# Count_values for sentiment
print(sf.count_values_in_column(tweet_df, 'sentiment'))

# Optional, create a Pie Chart
# sf.create_pie_chart(tweet_df, 'sentiment')

# Creating new data frames for all sentiments (positive, negative and neutral)
# tweets_negative = tweet_df[tweet_df['sentiment'] == 'negative']
# tweets_positive = tweet_df[tweet_df['sentiment'] == 'positive']
# tweets_neutral = tweet_df[tweet_df['sentiment'] == 'neutral']

# Optional Create Word Clouds
# Creating wordcloud for all tweets
# sf.create_wordcloud(tweet_df['text'].values, "all")
# sf.create_wordcloud(tweets_positive['text'].values, "positive")
# sf.create_wordcloud(tweets_negative['text'].values, "negative")

# Calculating tweet’s length and word count
tweet_df['text_len'] = tweet_df['text'].astype(str).apply(len)
tweet_df['text_word_count'] = tweet_df['text'].apply(lambda x: len(str(x).split()))

print("Average tweet length")
print(round(pd.DataFrame(tweet_df.groupby("sentiment").text_len.mean()), 2))

print("Average word count")
print(round(pd.DataFrame(tweet_df.groupby('sentiment').text_word_count.mean()), 2))

# remove punctuation
tweet_df['punct'] = tweet_df['text'].apply(lambda x: sf.remove_punct(x))

# Apply tokenization
tweet_df['tokenized'] = tweet_df['punct'].apply(lambda x: sf.tokenization(x.lower()))

# Removing stopwords
tweet_df['nonstop'] = tweet_df['tokenized'].apply(lambda x: sf.remove_stopwords(x))

# Applying Stemmer
tweet_df['stemmed'] = tweet_df['nonstop'].apply(lambda x: sf.stemming(x))

# Appliyng Countvectorizer
countVectorizer = CountVectorizer(analyzer=sf.clean_text)
countVector = countVectorizer.fit_transform(tweet_df['text'])
print('{} tweets have {} unique words'.format(countVector.shape[0], countVector.shape[1]))

count_vect_df = pd.DataFrame(countVector.toarray(), columns=countVectorizer.get_feature_names())

# Most Used Words
count = pd.DataFrame(count_vect_df.sum())
countdf = count.sort_values(0, ascending=False).head(20)
print(countdf[1:11])

# write the csv
tweet_df.to_csv(user + '_processed_tweets.csv', sep='\t')

# printing the bi-gram and tri-grams (words that are often used together)
print(sf.get_top_n_gram(tweet_df['text'], (2, 2), 10))

print(sf.get_top_n_gram(tweet_df['text'], (3, 3), 10))
