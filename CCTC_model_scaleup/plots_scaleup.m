% Generate plots from results in the 'recordings' folder
% Run this script after running mosinit_XX_scaleup.hoc at least once
% Author: Xu Zhang @UConn, Apr., 2019

clear;close all;

plot_condition = 'ET'; % Plot ET condition
% plot_condition = 'NORM'; % Plot normal condition

showStart = 1000;
showChop = 3000;

figure;

% PC raster plot
apPC = dlmread(strcat('recordings\',plot_condition,'_scaleup\ap_PC.txt'));
subplot(3,1,1);
hold on;
for i = 1:200
    tmpind = find(apPC(:,1)==i-1);
    tmpPC = apPC(tmpind,2);
    yyy = diff(tmpPC);
    mmm = find(abs(yyy)<1)+1;
    tmpPC(mmm)=[];
    plot(tmpPC,ones(length(tmpPC),1)*i,'k.');
end
title('PC');
xlim([showStart showChop]);
xlabel('Time (ms)');
ylabel('Neuron No.');

% ION raster plot
apION = dlmread(strcat('recordings\',plot_condition,'_scaleup\ap_ION.txt'));
subplot(3,1,2);
hold on;
for i = 1:40
    tmpind = find(apION(:,1)==i-1);
    tmpION = apION(tmpind,2);
    yyy = diff(tmpION);
    mmm = find(abs(yyy)<1)+1;
    tmpION(mmm)=[];
    plot(tmpION,ones(length(tmpION),1)*i,'k.');
end
xlim([showStart ceil(max(apION(:,2))/100)*100]);
title('ION');
xlim([showStart showChop]);
xlabel('Time (ms)');
ylabel('Neuron No.');

% Plot Vim spectrogram
apVim = dlmread(strcat('recordings\',plot_condition,'_scaleup\ap_Vim.txt'));
subplot(3,1,3);
spike_mat_all = zeros(5,5000);
tfin = 5000;
% Extract APs from each Vim neuron
for n = 1:5
    tmpind = find(apVim(:,1)==n-1);
    tmpVim = apVim(tmpind,2);
    yyy = diff(tmpVim);
    mmm = find(abs(yyy)<1)+1;
    tmpVim(mmm)=[];
    
    tbin = 1;
    tseries = tbin:tbin:tfin;
    spike_mat_tmp = zeros(1,length(tseries));
    for j = 1:length(tseries)-1
        for k = 1:length(tmpVim)
            tmpspike = tmpVim(k);
            if tseries(j)<=tmpspike && tseries(j+1)>tmpspike
                spike_mat_tmp(j) = 1;
            end
        end
    end
    spike_mat_all(n,:) = spike_mat_tmp;
    
end
% Temporal summation of APs across the 5 Vim neurons
spike_mat = sum(spike_mat_all,1);
spike_mat(spike_mat>1)=1;
% Compute spectrogram
[wt2,f] = cwt(spike_mat,1e3);
wt2 = wt2(end:-1:1,:);
f = f(end:-1:1);
wt2 = wt2(6:55,:);
f = f(6:55);
pcolor(1:5000,f,abs(wt2));shading interp
ylim([1 14]);
h = colorbar;
xlim([showStart showChop]);
xlabel('Time (ms)');
ylabel('Frequency (Hz)');
% caxis([0.02 0.05]);
title('Vim Spectrogram');
