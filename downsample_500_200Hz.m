function  [x_out1, x_out2, x_out3, x_out4, x_out5, x_out6]=downsample_500_200Hz(Xmuiltcols)
% 多个导联 返回6000点 采样率200hz
Lm =mean(Xmuiltcols(1:50,:), 1);
Rm =mean(Xmuiltcols(end-50:end, :), 1);
Xmuiltcols_ex = [repmat(Lm,50,1); Xmuiltcols; repmat(Rm,50,1)];
xcs_ex = resample(Xmuiltcols_ex, 200, 500);
x_out = xcs_ex(21:end-20,:);

x_out1 = x_out(:,1);
x_out2 = x_out(:,2);
x_out3 = x_out(:,3);
x_out4 = x_out(:,4);
x_out5 = x_out(:,5);
x_out6 = x_out(:,6);

end