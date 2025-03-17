from claid.module.module import Module
from spezi_claid import SleepData, SleepSample

class SomePythonTestModule(Module):

    def __init__(self):
        super().__init__()
        
    def initialize(self, properties):
        print("SomePythonTestModule initialized - hello!")
       
