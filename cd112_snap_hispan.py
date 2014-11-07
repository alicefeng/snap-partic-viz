### colorize_svg.py
     
import csv
from BeautifulSoup import BeautifulSoup
     
# Read in SNAP participation rates
snap_hispan = {}
min_value = 100; max_value = 0
reader = csv.reader(open('districtData.csv'), delimiter=",")
for row in reader:
  try:
    dist_name = "\"" + row[1] + "\""
    snap_hispan[dist_name] = float(row[6].strip())
  except:
    pass
     
     
# Load the SVG map
svg = open('112th_US_House.svg', 'r').read()
     
# Load into Beautiful Soup
soup = BeautifulSoup(svg, selfClosingTags=['defs','sodipodi:namedview'])
     
# Find counties
paths = soup.findAll('path')
     
# Map colors
colors = ["#C2C2C2", "#E1E1E1", "#9ECAE1", "#6BAED6", "#3182BD", "08519C"]

for p in paths:
    if (p['id'] != "State_Border") & (p['id'] != "State_Borders"):
      try:
        rate = snap_hispan["\""+p['id']+"\""]
      except:
        continue

    if rate > 0.4:
      color_class = 5
    elif rate > 0.25:
      color_class = 4
    elif rate > 0.2:
      color_class = 3
    elif rate > 0.143:
      color_class = 2
    elif rate > 0.07:
      color_class = 1
    else:
      color_class = 0

    color = colors[color_class]
    p['fill'] = color 

print soup.prettify()
     

