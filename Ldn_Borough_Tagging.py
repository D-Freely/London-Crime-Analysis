import pandas as pd

dataset['LSOA_name'] = dataset['LSOA_name'].str.strip()

ldn_brgh_lst = ['Barking and Dagenham','Barnet','Bexley','Brent','Bromley','Camden','Croydon','Ealing','Enfield','Greenwich','Hackney','Hammersmith and Fulham','Haringey','Harrow','Havering','Hillingdon','Hounslow','Islington','Kensington and Chelsea','Kingston upon Thames','Lambeth','Lewisham','Merton','Newham','Redbridge','Richmond upon Thames','Southwark','Sutton','Tower Hamlets','Waltham Forest','Wandsworth','Westminster']

def ldn_brgh_col(area):
    if area in ldn_brgh_lst:
        col_val = 'Y'
    else:
        col_val = 'N'
    return col_val

dataset['Ldn_Borough'] = dataset.apply(lambda x: ldn_brgh_col(x['LSOA_name']), axis=1)
