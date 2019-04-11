'''Test for the foobar.py module'''
from src.example import *
 
def test_answer():
    assert foobar(3, False) == 'result=3'
    assert foobar(3, True) == 'result=4'

def test_more():
    assert morefoo(3) == 9
