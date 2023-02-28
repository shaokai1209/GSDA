function [accuracy,c] = UAR(gtruth,pLbl);
%
% This fucntion is going to calculate uweighted average recall.  UAR is
% equal to the accuracy per class divided by the number of classes without
% consideration of instances per class. This function will work for n
% number of classes.
% 
% accuracy = UAR(gtruth,pLbl);
% 
% accuracy = UAR
%
% gtruth = true labels
% pLbl = predicted labels
% 
% 
% Written by Ali Hassan (ah07r@ecs.soton.ac.uk)
% Date: 20 Dec 2009

c = confusionmat(gtruth, pLbl);

d = diag(c);

m = sum(c,2)+0.001;

accuracy = sum(d./m/length(d));
