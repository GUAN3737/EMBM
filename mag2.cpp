#include "mex.h" 
#include <iostream>
#include "math.h"
///////////////////////////////////////////////////////////////////////////
 /////////////////////输入的时候别忘了tmp_x,tmp_y,sum_x,sum_y////////////
/////////////////////////////////////////////////////////////////////////////
//#define CHECK_INDEX(x1,x2,y1,y2,image_size1,image_size2){if (x1>=image_size1)	x1=2*image_size1-x1-2; if (x2<0) x2=-(x2+2); if (y1>=image_size2)  y1=2*image_size2-y1-2; if (y2<0)  y2=-(y2+2);}
#define CHECK_INDEX(x1,x2,y1,y2,image_size1,image_size2){if (x1>=image_size1)	x1=2*image_size1-x1-2; if (x2<0) x2=-(x2+1); if (y1>=image_size2)  y1=2*image_size2-y1-2; if (y2<0)  y2=-(y2+1);}
#define ori_img prhs[0]
#define dgau2D prhs[1]


#define Tmp_x plhs[0]
#define Tmp_y plhs[1]
#define Sum_x plhs[2]
#define Sum_y plhs[3]
#define X_detect plhs[4]
#define Y_detect plhs[5]
#define GJW plhs[6]////////////////////////////////////////////////////////////////////////////////////////////

// 定义输出参数

//#define MAG plhs[0]

 //double mag(double **image,double **dgau2D,int m,int n, int s){ //s=width  ori-img=image

  void mag2(double *tmp_x,double *tmp_y,double *sum_x,double *sum_y,double *x_detect, double *y_detect,double *gjw, double *p1, double *p2, int m, int n)
  {	
	long	x, y, x1, x2, y1, y2, x3, y3, i, j, aa, bb;//a, b用到了吗	
	//double	**x_detect, **y_detect
	/////////////////////////////////////////////////////////////////////////////
    //mxREAL tmp_y, sum_x, sum_y;
	////////////////////////////////////////////////////////////////////////////
	int s = 7;
	for(i=0;i<n;i++)	
	{
		for(j=0;j<m;j++)	
		{	
			y = i;
			x = j;
				sum_x[0] = 0.0;
				sum_y[0] = 0.0;
  				sum_x[1] = 0.0;
				sum_y[1] = 0.0;
				for (aa=-s; aa<=s; aa++)
				{
					x3=x+aa; y3=y+aa;
					CHECK_INDEX(x3,x3,y3,y3,m,n);
					//CHECK_INDEX(x3,x3,y3,y3,n,m);
					for (bb=1; bb<=s; bb++) 
					{
						y1=y+bb; y2=y-bb;
						x1=x+bb; x2=x-bb;
						CHECK_INDEX(x1,x2,y1,y2,m,n);
                       //CHECK_INDEX(x1,x2,y1,y2,n,m);
						//tmp_y[0] = p1[x1*m+y3]-p1[x2*m+y3];
						//tmp_x[0] = p1[x3*m+y1]-p1[x3*m+y2];
						tmp_y[0] = p1[y3*m+x1]-p1[y3*m+x2];
						tmp_x[0] = p1[y1*m+x3]-p1[y2*m+x3];
						sum_y[0] = tmp_y[0]*p2[(s+aa)+15*(s+bb)]; 
						sum_x[0] = tmp_x[0]*p2[(s+aa)+15*(s+bb)];
					   // sum_y[0] += tmp_y[0]*p2[(s+aa)*15+(s+bb)]; 
						//sum_x[0] += tmp_x[0]*p2[(s+aa)*15+(s+bb)];
                     
//                        sum_y[1] += sum_y[0];
//						sum_x[1] += sum_x[0]; 
					    x_detect[j*n+i] += sum_y[0];
			          	y_detect[j*n+i] += sum_x[0];// (i,j)改成了(j,i),没有求转置，不知道对不对啊
					   
				      
					 //x_detect[i*m+j] = sum_y[1];
					//	y_detect[i*m+j] = sum_x[1];// (i,j)改成了(j,i),没有求转置，不知道对不对啊
					}
				}  
			           if (i == 13 &&j == 14)//
						{
							gjw[0] = x_detect[j*m+i];
						
					    } 
					

			}
		 }
	
				      
 }


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
//nlhs：输出参数个数
//plhs：输出参数列表
//nrhs：输入参数个数
//prhs：输入参数列表

//double **ori_img,**dgau2D,**MAG;
int m,n;
double *p1,*p2,*tmp_x,*tmp_y,*sum_x,*sum_y,*x_detect,*y_detect,*gjw;

m = mxGetM(ori_img);

n = mxGetN(ori_img);


//MAG = mxCreateDoubleMatrix(m, n, mxREAL);
Tmp_x = mxCreateDoubleMatrix(1, 1, mxREAL);
Tmp_y = mxCreateDoubleMatrix(1, 1, mxREAL);
Sum_x = mxCreateDoubleMatrix(2, 1, mxREAL);
Sum_y = mxCreateDoubleMatrix(2, 1, mxREAL);
X_detect = mxCreateDoubleMatrix(n, m, mxREAL);
Y_detect = mxCreateDoubleMatrix(n, m, mxREAL);
GJW = mxCreateDoubleMatrix(1,1,mxREAL);///////////////////////////////////////////////////
// prhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);//输入用不用建立啊
// prhs[1] = mxCreateDoubleMatrix(m, n, mxREAL);//输入用不用建立啊

// 取得输入参数指针

p1 = mxGetPr(ori_img);

p2 = mxGetPr(dgau2D);

// 取得输出参数指针

//mag = mxGetPr(MAG);
tmp_x = mxGetPr(Tmp_x);
tmp_y = mxGetPr(Tmp_y);
sum_x = mxGetPr(Sum_x);
sum_y = mxGetPr(Sum_y);
x_detect = mxGetPr(X_detect);
y_detect = mxGetPr(Y_detect);
gjw = mxGetPr(GJW);  ////////////////////////////

mag2(tmp_x,tmp_y,sum_x,sum_y,x_detect,y_detect,gjw,p1,p2,m,n);

return;
	} 


//sizeof(mxREAL)
