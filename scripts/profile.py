#!/usr/bin/env python

import sys
import grass.script as gs
# on Windows, uncomment the two following lines
# import matplotlib  # required by Windows
# matplotlib.use('wx')  # required by Windows
import matplotlib.pyplot as plt


def profile(rasters, coordinates, filename, legend):
    profiles = {}
    distance = []
    for raster in rasters:
        profile = gs.read_command('r.profile', input=raster,
                                  coordinates=coordinates, quiet=True)
        profile = profile.strip()
        # parse output
        if not distance:
            for line in profile.splitlines():
                distance.append(float(line.split()[0]))
        profile_elev = []
        for line in profile.splitlines():
            profile_elev.append(float(line.split()[-1]))
        profiles[raster] = profile_elev

    fig = plt.figure(figsize=(8,3))
    for raster in profiles:
        plt.plot(distance, profiles[raster], label=raster,
                 color="#22BB11", linewidth=4.0)
        if legend:
            plt.legend(loc=0)

    plt.ylabel('elevation')
    plt.xlabel('distance')
    plt.savefig(filename, bbox_inches='tight')


def main():
    usage = "Usage:\n  %s raster coordinates output" % sys.argv[0]
    if len(sys.argv) != 4:
        exit("Wrong number of parameters\n%s" % usage)
    profile(rasters=[sys.argv[1]],
            coordinates=[sys.argv[2].split(',')],
            filename=sys.argv[3],
            legend=False)


if __name__ == '__main__':
    main()
