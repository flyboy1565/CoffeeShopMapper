from CoffeeShopMapper.routes import createDBConnection
import json

SHOPS = createDBConnection()


data = None
with open('SidewalkCafe.json', 'r') as f:
    data = json.loads(f.read())

if data:
    SHOPS.insert_many(data)