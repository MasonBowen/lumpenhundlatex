# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 11:57:42 2020

@author: tbowen
"""
#%%

import os
import pandas as pd
from matplotlib import pyplot as plt
from random import randint, randrange

#%%

dir_base = os.path.dirname(os.path.realpath(__file__))
dir_gen = os.path.join(dir_base, "..", "..", "Output Generator Files")

theor_gen_df = pd.read_pickle(os.path.join(dir_gen, "theoretical_generator_dataframe_with_layers.pkl"))

#%%
#
#qs = [i/100  for i in range(0,100) if i % 5 == 0]
#
#x = pd.Series(theor_gen_df.loc[0]['generation_hourly']).quantile(q=qs)
#
#%%

df_gen = pd.DataFrame({'generation': theor_gen_df.loc[:]['generation_hourly']})
df_gen.dropna(axis=0, subset=['generation'],inplace=True)

df_write = pd.DataFrame(index=range(8760),columns=range(len(df_gen)))
##%%
#for i 
#dfObj.assign(Marks = [10,20, 45, 33, 22, 11])
#
#
##df_gen.sort_values('generation', ascending=False, inplace=True)
##df_gen.reset_index(inplace=True, drop=True)
#
##%%
#
#plt.plot(df_gen.index,df_gen.generation)
#plt.xlabel("Index")
#plt.ylabel("DG Output")
#plt.title('Sorted DG Annual Generation')
#plt.show()