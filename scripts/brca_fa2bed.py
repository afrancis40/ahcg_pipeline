import sys

#Open file and split on commas
input = open('brca_variant.fa', 'r').read().split()

#Set up columns
a=input[9]
b=input[10]

start = a.split(',')
end = b.split(',')
#print (start)
#Loop and print
for a in range(23):
        print ("chr17" + "\t" + start[a] + "\t" + end[a] + "\t" + "BRCA1-NM_007294" + "\t" + "NA" + "\t" + "-")

