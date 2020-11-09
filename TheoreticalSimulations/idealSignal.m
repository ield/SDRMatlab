f1 = 100e3;
fs1 = 1e6;      Ts1 = 1/fs1;
fc = 100e6;
fs2 = 8e9;      Ts2 = 1/fs2;
frat = fs2/fs1;

t = 1e-3;          % Sampling seconds
N1 = fs1*t;
N2 = fs2*t;

n1 = 1:N1;
n2 = 1:N2;

x1 = cos(2*pi*f1*n1/fs1);
t1 = Ts1:Ts1:t;


carrier = cos(2*pi*fc*n2/fs2);
tcarr = Ts2:Ts2:t;

figure;
subplot(1, 2, 1)
plot(t1, x1);

subplot(1, 2, 2)
plot(tcarr, carrier);