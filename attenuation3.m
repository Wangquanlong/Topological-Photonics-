%function fem=single_mode_1(freq)


close all; 
clear all;
clc; 

resultnum='3';
dir='attenresults'; 
resultname='bob'; 

dirsub=[dir,resultnum]; 

%make directory for results 
if(exist(dirsub,'dir')==1)  %remove directory if already present 
    rmdir(dirsub);
end
mkdir(dirsub); 


freq=0.820;
% COMSOL Multiphysics Model M-file
% Generated by COMSOL 3.4 (COMSOL 3.4.0.248, $Date: 2007/10/10 16:07:51 $)

flclear fem

% COMSOL version
clear vrsn
vrsn.name = 'COMSOL 3.4';
vrsn.ext = '';
vrsn.major = 0;
vrsn.build = 248;
vrsn.rcs = '$Name:  $';
vrsn.date = '$Date: 2007/10/10 16:07:51 $';
fem.version = vrsn;

gamma=2.8*10^6;
Hs=1780;
H0=2020;
dH=0.5;  %this is from Pozar  
losstan=0.0002; 

w=14.5*10^9*(2*pi); 
w0=2*pi*gamma*H0;
wm=2*pi*gamma*Hs;
alpha=dH*gamma/2/w; 

%{
Xxxp=(w0*wm*(w0^2-w^2)+w0*wm*w^2*alpha^2)/( (w0^2-w^2*(1+alpha^2))^2+4*w0^2*w^2*alpha^2); 
Xxxpp=(alpha*w*wm*(w0^2+w^2*(1+alpha^2)))/( (w0^2-w^2*(1+alpha^2))^2+4*w0^2*w^2*alpha^2); 
Xxyp=(-w*wm*(w0^2-w^2*(1+alpha^2)))/( (w0^2-w^2*(1+alpha^2))^2+4*w0^2*w^2*alpha^2); 
Xxypp=(2*w0*wm*w^2*alpha)/( (w0^2-w^2*(1+alpha^2))^2+4*w0^2*w^2*alpha^2); 

Xxx=Xxxp-i*Xxxpp;
Xxy=Xxypp+i*Xxyp; 

a1=(1+Xxx);
khr=-i*Xxy; 
%}

%{
a1=(1+wm*(w0+i*alpha*w)/( (w0+i*alpha*w)^2-w^2));
khr=i*wm*w/( (w0+i*alpha*w)^2-w^2); 
%}

%lossless calculations 
w0=w0+i*alpha*w; 
a1=1+w0*wm/(w0^2-w^2);
khr=w*wm/(w0^2-w^2); 

% Constants
%need to include minus with losstan, otherwise this becomes gain...
fem.const = {'r1','0.15', ...
  'r2','0.15',...
  'eps1',15*(1-i*losstan), ...  
  'mu1',a1, ...
  'kappa1',khr, ...
  'freq',sprintf('%f',freq*3*10^8)};

% Geometry
%three rectangles, 2nd two correspond to PML regions we set up 

a=0.805; 
H=8; 
W=40; 
Wpml=2; 
Hpml=1.8;

offset=0.4; 
offset2=0.1; 
shift=0; 

g1=rect2(W+Wpml,H,'base','corner','pos',{'0','0'},'rot','0');
g2=rect2(Wpml,H,'base','corner','pos',{W,'0'},'rot','0');
g3=rect2(W,Hpml,'base','corner','pos',{'0','0'},'rot','0');
%create metal boundaries 



%creates left lattice
g4=circ2('r1','base','center','pos',{'0.5',0.5+offset2},'rot','0','const',fem.const);
gt1=geomarrayr(g4,1,1,W*3/4+shift,H);

%creates right lattice 
g5=circ2('r2','base','center','pos',{0.5+W*3/4+shift,0.5+offset},'rot','0','const',fem.const);
gt2=geomarrayr(g5,a,a,round((W/4-shift)/a),round(H/a)-1);


%adds point where we place current source 
parr={point2(3,H-0.1)};
gpoint=geomcoerce('point',parr);

% set geometry objects 
clear p s
p.objs={gpoint};  %point objects
s.objs={g1{:},g2{:},g3{:},gt1{:},gt2{:}}; %geometry objects 

fem.draw=struct('p',p,'s',s);
fem.geom=geomcsg(fem);




% Initialize mesh
fem.mesh=meshinit(fem, ...
                  'hauto',6);  %should use 6 for good accuracy 

% (Default values are not included)

% Application mode 1
clear appl
appl.mode.class = 'InPlaneWaves';
appl.module = 'RF';
appl.assignsuffix = '_rfwe';
clear pnt
pnt.I0 = {0,1};
pnt.ind = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ...
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
appl.pnt = pnt;
clear bnd
bnd.type = {'E0','cont'};
bnd.ind = [1,1,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  1,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, ...
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2];

appl.bnd = bnd;
clear equ
equ.epsilonr = {1,1,{1;1;'eps1'},1};
equ.Stype = {'coord','none','none','coord'};
equ.mur = {1,1,{'mu1','i*kappa1',0;'-i*kappa1','mu1',0;0,0,1},1};

%these seem to control something called infinite elements, not sure what
%this does, this infinite element region is basically a pml, we have two of
%them capping the ends of the system, these are set in subdomain settings 
equ.coordOn = {{0;1},{0;0},{0;0},{1;0}};
equ.sigma = {0,0,0,0};   %we need to set conductivity of region
equ.srcpnt = {{(W+Wpml)/2;0},{0;0},{0;0},{W;H/2}};
equ.Sd = {{'Sdx_guess_rfwe';5},{'Sdx_guess_rfwe'; ...
  'Sdy_guess_rfwe'},{'Sdx_guess_rfwe';'Sdy_guess_rfwe'},{5;'Sdy_guess_rfwe'}};
equ.ind = [1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, ...
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];
appl.equ = equ;

%needs frequecny input here 
appl.var = {'nu','freq'};
fem.appl{1} = appl;
fem.frame = {'ref'};
fem.border = 1;
clear units;
units.basesystem = 'SI';
fem.units = units;




% ODE Settings
clear ode
clear units;
units.basesystem = 'SI';
ode.units = units;
fem.ode=ode;
% Multiphysics
fem=multiphysics(fem);




% Extend mesh
fem.xmesh=meshextend(fem);

% Solve problem
fem.sol=femstatic(fem, ...
                  'complexfun','on', ...
                  'solcomp',{'Ez'}, ...
                  'outcomp',{'Ez'}, ...
                  'pname','freq', ...
                  'plist',freq*3e8, ...
                  'oldcomp',{});

              
              
              
% Plot solution
figure; 
postplot(fem, ...
         'tridata',{'Ez','cont','internal','unit','V/m'}, ...
         'tridlim',[-700 700], ...
         'trimap','wavemap(1024)', ...
         'title','Ez', ...
         'axis',[0,W,Hpml,H]);
      axis equal; 
     ylim([Hpml+3,H]); 
     xlim([0,W-Wpml-1]); 
     
figure; 
postplot(fem, ...
         'tridata',{'normPoav_rfwe','cont','internal','unit','V/m'}, ...
         'tridlim',[-700 700], ...
         'trimap','wavemap(1024)', ...
         'title','Power', ...
         'axis',[0,W,Hpml,H]);
      axis equal; 
     ylim([Hpml+3,H]); 
     xlim([0,W-Wpml-1]); 
          

     

     
     
    bob=xmeshinfo(fem); 
    data=bob.coords; 
    x=data(1,:);
    y=data(2,:);
    dataoutx=postinterp(fem,'Poxav_rfwe',[x;y]); 
    dataouty=postinterp(fem,'Poyav_rfwe',[x;y]); 
    dataoutE=postinterp(fem,'Ez',[x;y]);
    
    sd=size(dataoutx);
    sd=sd(1,2); 
    
    fp=fopen([dirsub,'/',resultname,'x','.txt'],'w');
    for n=1:1:sd
        fprintf(fp,'%f %f %f \n',x(1,n),y(1,n),dataoutx(1,n)); 
    end
    fclose(fp); 

    fp=fopen([dirsub,'/',resultname,'y','.txt'],'w');
    for n=1:1:sd
        fprintf(fp,'%f %f %f \n',x(1,n),y(1,n),dataouty(1,n)); 
    end
    fclose(fp); 
    
    %need seperate doir
    fp=fopen([dirsub,'/',resultname,'E','.txt'],'w');
    for n=1:1:sd
        fprintf(fp,'%f %f %f \n',x(1,n),y(1,n),dataoutE(1,n)); 
    end
    fclose(fp); 


    

     
                  
                  %{
% Plot solution
postplot(fem, ...
         'tridata',{'normPoav_rfwe','cont','internal','unit','V/m'}, ...
         'tridlim',[0 1400], ...
         'trimap','Rainbow', ...
         'title','freq', ...
         'axis',[0,W,Hpml,15.523863636363636]);
     %}

     
%{     
%we want to do processing on the solution
bob=xmeshinfo(fem); 
data=bob.coords; 
x=data(1,:);
y=data(2,:); 
val=fem.sol.u; %gives E-field


%}



