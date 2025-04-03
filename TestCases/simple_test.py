import unittest

# A simple function to test
def add(a, b):
    return a + b

# Test case class
class TestMathOperations(unittest.TestCase):

    # Test method to check if the addition is correct
    def test_add(self):
        self.assertEqual(add(3, 4), 7)  # Expected result: 3 + 4 = 7

    # Another test to check for negative numbers
    def test_add_negative(self):
        self.assertEqual(add(-3, 4), 1)  # Expected result: -3 + 4 = 1

# To run the test case
if __name__ == '__main__':
    unittest.main()