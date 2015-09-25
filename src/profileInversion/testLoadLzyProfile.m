%%反演工区路径
path='E:\苏里格\Sulige Inversion150403\';
path2='2测井曲线\测井曲线(处理后)\profile_model\';
filename3='profile_Depth.txt';filename=[path,path2,filename3];load(filename);profile_Depth=profile_Depth';
filename4='profile_Vp.txt';   filename=[path,path2,filename4];load(filename);profile_Vp=profile_Vp';
filename5='profile_Vs.txt';   filename=[path,path2,filename5];load(filename);profile_Vs=profile_Vs';
filename6='profile_Den.txt';  filename=[path,path2,filename6];load(filename);profile_Den=profile_Den';
filename7='profile_Por.txt';  filename=[path,path2,filename7];load(filename);profile_Por=profile_Por';
filename8='profile_Sw.txt';   filename=[path,path2,filename8];load(filename);profile_Sw=profile_Sw';
filename9='profile_Clay.txt'; filename=[path,path2,filename9];load(filename);profile_Clay=profile_Clay';
%%

profileWelllog = zeros(7, 80, 601);

profileWelllog(1, :, :) = profile_Depth;
profileWelllog(2, :, :) = profile_Vp;
profileWelllog(3, :, :) = profile_Vs;
profileWelllog(4, :, :) = profile_Den;
profileWelllog(5, :, :) = profile_Por;
profileWelllog(6, :, :) = profile_Sw;
profileWelllog(7, :, :) = profile_Clay;

% stpPaintProfile(profileWelllog);