% SLR PLOT
% Plots Sea Level Rise data for individual locations
% Written by Richard Buzard
% May 25, 2022

%% LOAD DATA

mt = readtable('SLR_TF US Sea Level Projections.csv','Range',[18 1]); % table has text
m = readmatrix('SLR_TF US Sea Level Projections.csv','Range',[19 1]); % matrix is easier to plot
%% CHOOSE LOCATION

xya = inputdlg({'Latitude','Longitude'},...
    'Enter Coordinate',[1 35],{'71','-157'});

% find closest point
ya = str2double(xya{1});
xa = str2double(xya{2});
%ha = sqrt((xa-m.Long).^2+(ya-m.Lat).^2); % distance from entry to grid
ha = sqrt((xa-m(:,7)).^2+(ya-m(:,6)).^2); % distance from entry to grid
idx = find(ha==min(ha));                 % closest solution

% format data into plottable matrix
x = [2005 2020:10:2150];        % dates
x2 = [x, fliplr(x)];            % for area plot
s03 = 1:3;                      % scenario index
s05 = 4:6;
s10 = 7:9;
s15 = 10:12;
s20 = 13:15;

s = [s03;s05;s10;s15;s20];
itemNames ={...
    'S1: GMSL 0.3 m by 2100',...
    'S2: GMSL 0.5 m by 2100',...
    'S3: GMSL 1.0 m by 2100',...
    'S4: GMSL 1.5 m by 2100',...
    'S5: GMSL 2.0 m by 2100'};

lineColors =...
    [153 204 0;
    255 204 0;
    255 102 0;
    204 0 0;
    102 0 51]./255;

%% Plot interactive graph

plotOptions(m,x,x2,idx,itemNames,lineColors);

%% FUNCTIONS
function plotOptions(m,x,x2,idx,itemNames,lineColors)
fig = uifigure;
fig.Position(3:4) = [530 330];
ax = uiaxes('Parent',fig,...
    'Position',[120 10 400 300]);
ax.YAxisLocation = 'right';
ax.YGrid = 'on';
ax.Box = 'on';


% ss=2;
% s = (ss*3-2):ss*3;
% fill(ax,x2,[m(idx(s(2)),14:28),...
%     fliplr(m(idx(s(3)),14:28))],...
%     lineColors(ss,:),'EdgeColor','none','FaceAlpha',0.3);
% hold(ax,'on')
% plot(ax,x,m(idx(s(1)),14:28),'-','Color',lineColors(ss,:));


ax.XAxis.TickValues = 2000:10:2150;
ax.XTickLabel = {2000,'','','','',2050,'','','','',2100,'','','','',2150};
ax.XAxis.TickLabelRotation = 0;
%title(ax,itemNames(ss))
ylabel(ax,'Sea Level Rise (cm)','rotation',90)

%legend(ax,itemNames,'Location','northwest')

% dd = uidropdown(fig,...
%     'Items',itemNames,...
%     'Value', itemNames{1},...
%     'Position',[20 310 120 22],...
%     'ValueChangedFcn',@(dd,event) selection(dd,m,x,x2,idx,itemNames,ax));

cbx1.Value = 0;
cbx2.Value = 0;
cbx3.Value = 0;
cbx4.Value = 0;
cbx5.Value = 0;

cbx1 = uicheckbox(fig,'Text',itemNames{1}(1:14),...
                  'Value', 0,...
                  'Position',[10 20 110 22],...
                  'ValueChangedFcn',@(cbx1,event) selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax));
cbx2 = uicheckbox(fig,'Text',itemNames{2}(1:14),...
                  'Value', 0,...
                  'Position',[10 40 110 22],...
                  'ValueChangedFcn',@(cbx2,event) selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax));
cbx3 = uicheckbox(fig,'Text',itemNames{3}(1:14),...
                  'Value', 0,...
                  'Position',[10 60 110 22],...
                  'ValueChangedFcn',@(cbx3,event) selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax));
cbx4 = uicheckbox(fig,'Text',itemNames{4}(1:14),...
                  'Value', 0,...
                  'Position',[10 80 110 22],...
                  'ValueChangedFcn',@(cbx4,event) selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax));
cbx5 = uicheckbox(fig,'Text',itemNames{5}(1:14),...
                  'Value', 0,...
                  'Position',[10 100 110 22],...
                  'ValueChangedFcn',@(cbx5,event) selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax));

 btn = uibutton(fig,'Position',[10 290 80 22],'Text','Save PNG',...
     'ButtonPushedFcn', @(btn,event) btnGotPushed(fig));
 
end


function selection(cbx1,cbx2,cbx3,cbx4,cbx5,m,x,x2,idx,lineColors,ax)
    cla(ax);
    p=[];
    lg = {'','','','','',''};
    cbx = [cbx1.Value, cbx2.Value, cbx3.Value, cbx4.Value, cbx5.Value];
    itemNames ={...
    'GMSL 0.3 m by 2100',...
    'GMSL 0.5 m by 2100',...
    'GMSL 1.0 m by 2100',...
    'GMSL 1.5 m by 2100',...
    'GMSL 2.0 m by 2100'};

    for ss = 1:length(cbx)
        if cbx(ss)==1
            s = (ss*3-2):ss*3;
            fill(ax,x2,[m(idx(s(2)),14:28),...
                fliplr(m(idx(s(3)),14:28))],...
                lineColors(ss,:),'EdgeColor','none','FaceAlpha',0.5);
            hold(ax,'on')
            p(ss) = plot(ax,x,m(idx(s(1)),14:28),'-','Color',lineColors(ss,:));
        end
    end
    if ~isempty(p)
        legend(p(find(cbx)),itemNames{find(cbx)},'Location','Northwest');
    end
%title(ax,dd.Value)

end

function btnGotPushed(fig)
    exportapp(fig,'SLR.png')
end