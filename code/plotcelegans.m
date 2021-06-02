# octave code (plot commands are ancient, and you may have to edit it to get it to work).
# data are in ../scaled-data
function plotcelegans()

load -force scaledbodya.dat
load -force scaledbodyb.dat
load -force scaledbodyc.dat
load -force scaledheada.dat
load -force scaledheadb.dat
load -force scaledtaila.dat
load -force scaledtailb.dat

hold on;
plot(scaledbodya(:,1), scaledbodya(:,2), "1*-", scaledbodyb(:,1), scaledbodyb(:,2), "2*-", scaledbodyc(:,1), scaledbodyc(:,2), "3*-", scaledheada(:,1), scaledheada(:,2), "4*-", scaledheadb(:,1), scaledheadb(:,2), "5*-", scaledtaila(:,1), scaledtaila(:,2), "6*-", scaledtailb(:,1), scaledtailb(:,2), "7*-");

gset output "celegans-all.ps";
gset term postscript eps color "Helvetica" 18;
replot;
hold off;

endfunction
