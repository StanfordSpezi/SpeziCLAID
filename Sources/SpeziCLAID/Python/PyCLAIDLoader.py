
from claid.CLAID import CLAID
from claid.module.module import Module
import asyncio
import os
from module.module_factory import ModuleFactory


module_factory = ModuleFactory()

def import_and_add_module(file_folder_path, python_file_name, module_name):
    print("PyCLAID:")
    print(file_folder_path)
    print(python_file_name)
    print(module_name)
    result = module_factory.inject_claid_modules_from_python_file(file_folder_path, python_file_name, [module_name])
    print("Import result ", result)
    # Todo: Bug in CLAID 0.6.4, as module_factory.inject_claid_modules_from_python_file does not return anything,
    # Todo: although the underlying ModuleInjector does. 
    return True
       
        

def attach_python_runtime():
    print("Attaching Python Runtime")
    claid = CLAID()

    asyncio.run(claid.start_python_only("localhost:1337", module_factory))
    return True
