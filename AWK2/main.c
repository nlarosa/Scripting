
#include<stdio.h>


void main(void){

 	int sq = 9.0;
	int	rt = 1.0;
	
	sq = rt;
	float sqrt = (float)(sq+rt);
	
	int po = 9;
	int w = 4;
	
	int*   pow = (int*)malloc(sizeof(int)*1000);
	
	int i;
	
	for(i=0; i<200; ++i){
		pow[i] = po*i+w;
		if(i==100)
			pow[i] = 40;
	}
	
	sqrt = (float) pow[40];

	printf("\t zap bam pow =) \n");

}
