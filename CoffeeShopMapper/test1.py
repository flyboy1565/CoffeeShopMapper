import bottle, unittest
from boddle import boddle
from routes import *

class TestIt(unittest.TestCase):
    def test_home_page(self):
        with boddle(path="/"):
            self.assertTrue('Coffee Shop Search' in home())
    def test_search(self):
        with boddle(path="/search", query={'searchValue': 'mi'}):
            self.assertGreater(len(search()), 0)
    def test_query_all(self):
        with boddle(path="/getAll"):
            self.assertGreater(len(get_all()), 0)

if __name__=='__main__':
    unittest.main()