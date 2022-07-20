"""
Routes and views for the bottle application.
"""
import re
from sqlite3 import Cursor
from bson.objectid import ObjectId
from bson.json_util import dumps
from bottle import route, view, request
from pymongo import MongoClient, errors
from ast import literal_eval

# try to connect to the database
try:
    client  = MongoClient('mongodb://docker:mongopw@localhost:49153/CoffeeShops?authSource=admin')
    db = client.CoffeeShops
    SHOPS = db.shops
except errors.ServerSelectionTimeoutError as err:
# if connection fails print the message below
    client = None
    print("PyMongo doesn't appear to be allowing a connection")

@route('/')
@route('/home')
@view('index')
def home():
    """This renders the default index.tpl page"""
    return dict()

# this allows get and delete methods
# the allows the user to supply an id value to get a response
@route('/<id>', methods=("GET", "DELETE"))
def one_item(id):
    if id == "null" or id is None or id.endswith('ico'):
        # return empty dictionary if any above condition is true 
        return dict()
    if request.method == 'GET':
        # get 1 record 
        cursor = SHOPS.find_one(ObjectId(id))
        return dumps(cursor)
    else:
        # delete 1 record
        SHOPS.delete_one({'_id':ObjectId(id)})
        return {}

# put method allows users to create a new entry     
@route('/add', methods=('GET',))
def add_one():
    data = {}
    for key, value in request.query.items():
        if key is not None:
            data = literal_eval(key)
    SHOPS.insert_one(data)
    cursor = SHOPS.find({"name":data['Name']})
    return dumps(cursor)


# search uses the get method to wildcard search for coffeeshops
@route('/search', methods=("GET",))
def search():
    search=request.query.get("searchValue")
    # we're using regex with a ignore case setting
    rgx = re.compile('.*{}.*'.format(search), re.IGNORECASE) 
    cursor = SHOPS.find({"Name":rgx})
    return dumps(cursor)


# provides all records from the database
@route('/getAll', methods=("GET",))
def get_all():
    cursor = SHOPS.find()
    data = dumps(cursor)
    return data