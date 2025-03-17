from claid.module.module import Module
from spezi_claid import SleepData, SleepSample

class MyAggregator(Module):

    def __init__(self):
        super().__init__()
        
    def initialize(self, properties):
        print("MyAggregator initialized")
        self.register_remote_function("analyze_sleep_data", self.analyze_sleep_data, SleepData(), int(0))

    def analyze_sleep_data(self, code: int):
        print("Analyze sleep data function called")
        data = SleepData()
        sample = SleepSample()
        sample.value = 42
        data.sleep_samples = sample
        
        return data
