from claid.module.module import Module

class MyAggregator(Module):

    def __init__(self):
        super().__init__()
        
    def initialize(self, properties):
        print("MyAggregator initialized")
