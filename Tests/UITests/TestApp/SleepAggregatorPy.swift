
import SpeziCLAID

class SleepAggregatorPy : CLAIDPythonModule {
   
    init(moduleId: String) {
        super.init(
            pythonModuleFile: "MyAggregator.py",
            pythonModuleClass: "MyAggregator",
            pythonModuleId: moduleId
        )
    }
}
