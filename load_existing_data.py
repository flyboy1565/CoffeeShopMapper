from pymongo import MongoClient
import json

uri = 'mongodb://docker:mongopw@localhost:49153/?authSource=admin'
client = MongoClient(uri)
db = client['CoffeeShops']
SHOPS = db['shops']


data = None
with open('SidewalkCafe.json', 'r') as f:
    data = json.loads(f.read())

if data:
    SHOPS.insert_many(data)