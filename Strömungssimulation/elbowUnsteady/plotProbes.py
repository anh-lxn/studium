#!/usr/bin/python3

#import matplotlib
#matplotlib.use("GTK3Agg")
import matplotlib.pyplot as plt
import numpy as np
import argparse
import glob
import warnings


def readHeader(fileName):
    probes = list()
    print('Reading '+fileName)
    with open(fileName, 'r') as pFile:
        for line in pFile:
            lsplit = line.split()
            if lsplit[1] == 'Time':
                return probes
            if lsplit[3].startswith('('):
                probes.append([lsplit[3][1:], lsplit[4], lsplit[5][:-1]])
#            print(lsplit[3])

def readVector(fileName, nProbes):
    with open(fileName, 'r') as pFile:
        datalines = pFile.readlines()[nProbes+2:]
        data = [[float(val.strip("()")) for val in line.split()] for line in datalines]
    npData = np.array(data)
#    print(npData[2,:])
    return npData

def plotVector(data, probes, field):
    if field == 'U':
        cmpt = 3
        unit = 'm/s'
        direction="xyz"
    elif field == 'p':
        cmpt = 1
        unit = "m^2/s^2"
        direction = " "
    else:
        warnings.warn("No plot setting for field {0}. Using scalar settings.".format(field))
        cmpt = 1
        unit = '-'
        direction = " "
    for ip, probe in enumerate(probes):
        fig, ax = plt.subplots()
        ax.set(xlabel='time [s]', ylabel="{0} [{1}]".format(field, unit), title = "Probe {0} at ({1}, {2}, {3})".format(ip, probe[0], probe[1], probe[2]))
        for c in range(cmpt):
            ax.plot(data[:,0], data[:,1+c+ip*cmpt], label="{0}{1}".format(field,direction[c]))
        ax.legend()

        plt.savefig("./Strömungssimulation/elbowUnsteady/figs/{0}_{1}".format(field,ip))

def main():
    fileNames = glob.glob('./Strömungssimulation/elbowUnsteady/postProcessing/probes/0/*')
    for fileName in fileNames:
        field = fileName.split('/')[-1]

        probes = readHeader(fileName)
        data = readVector(fileName, len(probes))
        plotVector(data, probes, field)

    #plt.show()


if __name__ =='__main__':
    main()


