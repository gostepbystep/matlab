% 测试三次样条函数
clc;
clear;
close all;

x = 0 : 1 : 10;
y = sin(x);

u = 0 : 0.1 : 10;
[s] = stpCubicSpline(x, y, u, 0, 0);
