
from claid.CLAID import CLAID
from claid.module.module import Module
import asyncio
import os
from module.module_factory import ModuleFactory

class PythonCalculator(Module):
    
    def __init__(self):
        super().__init__()
        
    def initialize(self, properties):
        self.__input_channel = self.subscribe("InputChannel", 42, self.on_data)
        
    def on_data(self, value):
        print("Python Module says: ", value.get_data())
       
        

def start():
    print("Test")
    claid = CLAID()
    module_factory = ModuleFactory()
    module_factory.register_module(PythonCalculator)
    asyncio.run(claid.start_python_only("localhost:1337", module_factory))
    return True
