# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 13:16:53 2020

@author: tbowen
"""


#%%
import requests
import pandas as pd
import os
import re

#%%

url = "https://openei.org/apps/USURDB/?utilRateFindByZip=80215&service_type=&is_default=&search="

#%%

r = requests.get(url)
j = r.json(verify=False)
