function [v,x] = vel(a,time)

syms t
v = a*t;
x = a*t.^2;

v = subs(v,t,time); v = double(v);
x = subs(x,t,time); x = double(x);

end