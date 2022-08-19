# CoffeeShopMapper

How to get and use this code. 
```
git clone https://github.com/flyboy1565/CoffeeShopMapper.git
```

Create a virtual environment. Note we're using python virual environment
```
python3.6 -m venv .venv
```
Activate the virutal environment
```
-- windows
.venv/Scripts/activate
-- unix
source .venv/bin/activate
```
Install the required python packages. Note we're using pip.
```
cd CoffeeShopMapper
pip3 install -r CoffeeShopMapper/requirements.txt
```

Once you're requirements are setup, you should have a MongoDB database URI to update routes.py
```
uri = "mongodb://studentmysql:27017/?readPreference=primary&appname=MongoDB%20Compass%20Community&ssl=false"
```
This should be replaced with you're URI.

Also if you to change the "database" name you would also change 
```
db = client.<new_name>
```

After you have changed those settings you can load data from your JSON file to your database by using the script `CoffeeShopMapper/load_existing_data.py`.

Finally to start the server you would do 
```
python app.py
```
