% plot_sampled_v.m

load DCN_v_all.txt
load NO_v_all.txt
load PC_v_all.txt
load Vim_v_all.txt

D=DCN_v_all';
N=NO_v_all';
P=PC_v_all';
V=Vim_v_all';

t=[0:0.0125:6000];

figure
hold on
title('DCN')
plot(t,D)

figure()
hold on
plot(t, N)
title('NO')

figure()
hold on
plot(t,P)
title('PC')

figure()
hold on
plot(t,V)
title('Vim')

figure
subplot(2,2,1)
hold on
plot(t,D)
title('DC')

subplot(2,2,2)
hold on
plot(t,V)
title('Vim')

subplot(2,2,3)
hold on
plot(t,P)
title('PC')

subplot(2,2,4)
hold on
plot(t,N)
title('NO')

%num_of_graphs = h_index-1;
%for h_index = 1: num_of_graphs
%  print(h(h_index),['figure_' num2str(h_index) '.pdf'],'-dpdflatexstandalone');
%end
