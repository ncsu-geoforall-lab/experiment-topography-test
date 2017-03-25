# experiment-topography-test
Test of understanding topography


In GRASS GIS session on Linux in the repository directory run:

    ./scripts/create_test.sh `ls -v scripts/task1_* | xargs -n 1 basename`

To get only one of the task at a time:

    ./scripts/create_test.sh task1_10.sh
