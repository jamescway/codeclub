[0,1,2,3,4,5,6,7,8]

size = 9


For each iteration find the left(L), right(R), and midpoint(M)

M is defined  L+R/2  which finds the index of the midpoint between two index locations

Start L = 0
Start R = array.size - 1  (array positions start 0)

If the value you are looking for is less than the midpoint, then its on the left side
thus L = L  and you shift R to the M  thus R = M

If it was bigger than L = M and R = R.  R is not shifted, L is shifted to midpoint

Continue looping until you L & R are within on index of each other (i.e. indexes 3,4)

Then check if L or R is equal to the value you are looking for
If neither is equal to the value return -1