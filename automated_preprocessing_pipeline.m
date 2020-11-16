%%%%%% Thank you Dr. Kathleen Van Benthem for assistance on this script.
 
eeglab % the present study used eeglab 2019
 
%% Setting directories 

% The study had 4 different counterbalances. The first entry ('CB') must
% specify the correct counterbalance for select participants. This script 
% was executed 4 times: once for all participants of each CB 

CB = 4; 

% Variable for Epoch rejection code
pipeline_visualizations_semiautomated = 0


src_folder_name = '#' % create a folder for each CB. Select the CB folder that corresponds to CB value above.
src_file_ext = '.edf'
cd (src_folder_name);

% set the filenames for the looping through the folder
FileNames=dir(['*' src_file_ext]);
FileNames={FileNames.name};
% set the variable names used below


%% load the files in the folder set above one by one, selects the appropriate EEG parameters and inserts EEG triggers according to counter balance.
    
for current_file = 1:length(FileNames)
    EEG = pop_biosig((FileNames{current_file}));
    EEG.setname='loadset';
    EEG = eeg_checkset( EEG );
    EEG = pop_chanevent(EEG, 20,'edge','leading','edgelen',0);
    events=EEG.event;
    complete_event_info=EEG.urevent;
    srate=double(EEG.srate);
    EEG = eeg_checkset( EEG );
    EEG = pop_select( EEG,'channel',{'AF3' 'F3' 'FC5' 'P7' 'O1' 'P3' 'T7' 'T8' 'P4' 'O2' 'P8' 'FC6' 'F4' 'AF4'});
    EEG = pop_editset(EEG, 'chanlocs', [src_folder_name filesep 'EPOC_LOCS14.ced']); %channel locations file must be in source folder. See site for download. 

    %%% the following section gets the time of the triggers that indicate
    %%% the start and end of each circuit of flight
    start1 = eeg_getepochevent(EEG, '1',[],'latency')
    end1 = eeg_getepochevent(EEG, '2',[],'latency')
    start2 = eeg_getepochevent(EEG, '3',[],'latency')
    end2 = eeg_getepochevent(EEG, '4',[],'latency')
    start3 = eeg_getepochevent(EEG, '5',[],'latency')
    end3 = eeg_getepochevent(EEG, '6',[],'latency')
    start4 = eeg_getepochevent(EEG, '7',[],'latency')
    end4 = eeg_getepochevent(EEG, '8',[],'latency')

    Aleg1=128*start1/1000 % length(start1:end1)/1000%  EEG.xmax))*.25  this is the conversion of the circuit start latencies into "points" for later use
    leg1 = length(start1:end1)/1000  % total time that circuit took to fly...divided by 1000 to convert to seconds from ms

    Aleg2=128*start2/1000 %length(start2:end2)/1000 %EEG.xmax))*.5
    leg2 = length(start2:end2)/1000

    Aleg3=128*start3/1000%length(start3:end3)/1000% EEG.xmax))*.75
    leg3 = length(start3:end3)/1000

    Aleg4= 128*start4/1000%length(start4:end4)/1000%EEG.xmax)
    leg4 = length(start4:end4)/1000

    %Determine the est. start and end time of first turn, second turn,(hwl)
    % and the the runway segment (lwl)for each circuit
    time11=Aleg1+(leg1*.15*128)  %  .15 is the est start of base, and have to mulitply by 128 (sampling rate) and add this time to the start time of the circuit
    time12=Aleg1+leg1*.33*128
    time13=Aleg1+leg1*.68*128
    time14=Aleg1+leg1*.85*128
    time15=Aleg1+leg1*.40*128
    time16=Aleg1+leg1*.58*128

    time21=Aleg2+(leg2*.15)*128
    time22=Aleg2+(leg2*.33)*128
    time23=Aleg2+(leg2*.68)*128
    time24=Aleg2+(leg2*.85)*128
    time25=Aleg2+(leg2*.40)*128
    time26=Aleg2+(leg2*.58)*128

    time31=Aleg3+(leg3*.15)*128
    time32=Aleg3+(leg3*.33)*128
    time33=Aleg3+(leg3*.68)*128
    time34=Aleg3+(leg3*.85)*128
    time35=Aleg3+(leg3*.40)*128
    time36=Aleg3+(leg3*.58)*128

    time41=Aleg4+(leg4*.15)*128
    time42=Aleg4+(leg4*.33)*128
    time43=Aleg4+(leg4*.68)*128
    time44=Aleg4+(leg4*.85)*128
    time45=Aleg4+(leg4*.40)*128
    time46=Aleg4+(leg4*.58)*128
%     EEG = pop_saveset(EEG, 'filename',strrep(FileNames{current_file},'.edf', '_WL_load.set'),'filepath',src_folder_name) % save with original name and new extension in original folder
    EEG = eeg_checkset( EEG );
    
%1 lwl 2 hwl 3 lwl 4 hwl
% start with condition 1  %%%%%%ONLY ADDING IN THE FIRST TRIGGER FOR LATER
% EPOCHING

    if CB ==1
   
        EEG = eeg_addnewevents(EEG, {[time11]}, {['4411']},[],[]); % 44__ = curves HWL and 22__= runway LWL  __1_ = low WL circuit  and ___1 = first circuit
        EEG = eeg_addnewevents(EEG, {[time13]}, {['4411']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time15]}, {['2211']},[],[]);
        EEG = eeg_checkset(EEG, 'checkur'); % Making sure that the new markers are added to the full set of markers
    %2
        EEG = eeg_addnewevents(EEG, {[time21]}, {['4422']},[],[]); % start of base and cross and the runway segments during the highwl circuits, with radio calls
        EEG = eeg_addnewevents(EEG, {[time23]}, {['4422']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time25]}, {['2222']},[],[]);
        EEG = eeg_checkset(EEG, 'checkur');
    %3
        EEG = eeg_addnewevents(EEG, {[time31]}, {['4413']},[],[]);% start of base and cross and the runway segments during the low wl circuits, without radio calls
        EEG = eeg_addnewevents(EEG, {[time33]}, {['4413']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time35]}, {['2213']},[],[]);
        EEG = eeg_checkset(EEG, 'checkur');
    %4
        EEG = eeg_addnewevents(EEG, {[time41]}, {['4424']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time43]}, {['4424']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time45]}, {['2224']},[],[]);
        EEG = eeg_checkset(EEG, 'checkur');
    end

      
   
    if CB ==2
       % 2 hwl 3 lwl 4 hwl 1lwl

       % start with condition 2
        EEG = eeg_addnewevents(EEG, {[time11]}, {['4421']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time13]}, {['4421']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time15]}, {['2221']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time21]}, {['4412']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time23]}, {['4412']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time25]}, {['2212']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time31]}, {['4423']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time33]}, {['4423']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time35]}, {['2223']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time41]}, {['4414']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time43]}, {['4414']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time45]}, {['2214']},[],[]);
        EEG = eeg_checkset( EEG );
    end

    if CB ==3
        % 3 4 1 2
        %start with condition 3

        EEG = eeg_addnewevents(EEG, {[time11]}, {['4411']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time13]}, {['4411']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time15]}, {['2211']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time21]}, {['4422']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time23]}, {['4422']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time25]}, {['2222']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time31]}, {['4413']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time33]}, {['4413']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time35]}, {['2213']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time41]}, {['4424']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time43]}, {['4424']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time45]}, {['2224']},[],[]);
        EEG = eeg_checkset( EEG );
    end

    if CB ==4
        %4 1 2 3
        %start with condition 4

        EEG = eeg_addnewevents(EEG, {[time11]}, {['4421']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time13]}, {['4421']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time15]}, {['2221']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time21]}, {['4412']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time23]}, {['4412']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time25]}, {['2212']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time31]}, {['4423']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time33]}, {['4423']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time35]}, {['2223']},[],[]);
        EEG = eeg_checkset( EEG );

        EEG = eeg_addnewevents(EEG, {[time41]}, {['4414']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time43]}, {['4414']},[],[]);
        EEG = eeg_addnewevents(EEG, {[time45]}, {['2214']},[],[]);
        EEG = eeg_checkset( EEG );
    end
    %% 
    % next section adds in new events at one second intervals after the
    % marker indicating the workload, flight segment, and circuit (as above)
    if CB ==1 || CB ==3
        z=1
        d=time11;
        e=time13;
        f=time21;
        g=time23;
        h=time31;
        j=time33;
        k=time41;
        l=time43;

        while z < 30
            z=z+1;
            d=d+128;
            e=e+128;
            f=f+128;
            g=g+128;
            h=h+128;
            j=j+128;
            k=k+128;
            l=l+128;

            EEG = eeg_addnewevents(EEG, {[d]}, {['4411']},[],[]);
            EEG = eeg_addnewevents(EEG, {[e]}, {['4411']},[],[]);
            EEG = eeg_addnewevents(EEG, {[f]}, {['4422']},[],[]);
            EEG = eeg_addnewevents(EEG, {[g]}, {['4422']},[],[]);
            EEG = eeg_addnewevents(EEG, {[h]}, {['4413']},[],[]);
            EEG = eeg_addnewevents(EEG, {[j]}, {['4413']},[],[]);
            EEG = eeg_addnewevents(EEG, {[k]}, {['4424']},[],[]);
            EEG = eeg_addnewevents(EEG, {[l]}, {['4424']},[],[]);

        end
        zz=1
        m=time15;
        n=time25;
        o=time35;
        p=time45;

        while zz <60
            zz=zz+1;
            m=m+128;
            n=n+128;
            o=o+128;
            p=p+128;
            EEG = eeg_addnewevents(EEG, {[m]}, {['2211']},[],[]);
            EEG = eeg_addnewevents(EEG, {[n]}, {['2222']},[],[]);
            EEG = eeg_addnewevents(EEG, {[o]}, {['2213']},[],[]);
            EEG = eeg_addnewevents(EEG, {[p]}, {['2224']},[],[]);
        end
    end
    
    if CB ==2 || CB ==4
        z=1
        d=time11 ;
        e=time13;
        f=time21;
        g=time23;
        h=time31;
        j=time33;
        k=time41;
        l=time43;

        while z < 30
            z=z+1
            d=d+128;
            e=e+128;
            f=f+128;
            g=g+128;
            h=h+128;
            j=j+128;
            k=k+128;
            l=l+128;

            EEG = eeg_addnewevents(EEG, {[d]}, {['4421']},[],[]);
            EEG = eeg_addnewevents(EEG, {[e]}, {['4421']},[],[]);
            EEG = eeg_addnewevents(EEG, {[f]}, {['4412']},[],[]);
            EEG = eeg_addnewevents(EEG, {[g]}, {['4412']},[],[]);
            EEG = eeg_addnewevents(EEG, {[h]}, {['4423']},[],[]);
            EEG = eeg_addnewevents(EEG, {[j]}, {['4423']},[],[]);
            EEG = eeg_addnewevents(EEG, {[k]}, {['4414']},[],[]);
            EEG = eeg_addnewevents(EEG, {[l]}, {['4414']},[],[]);

        end
        zz=1
        m=time15;
        n=time25;
        o=time35;
        p=time45;

        while zz <60
            zz=zz+1;
            m=m+128;
            n=n+128;
            o=o+128;
            p=p+128;
            EEG = eeg_addnewevents(EEG, {[m]}, {['2221']},[],[]);
            EEG = eeg_addnewevents(EEG, {[n]}, {['2212']},[],[]);
            EEG = eeg_addnewevents(EEG, {[o]}, {['2223']},[],[]);
            EEG = eeg_addnewevents(EEG, {[p]}, {['2214']},[],[]);
        end
    end
%     EEG = pop_eegfiltnew(EEG, 0.1,40,[],0,[],0); %% CHANGE UPPER LIMIT TO WHAT YOU WANT  NOW AT 40 HZ

    EEG = pop_epoch( EEG, {  '2211'  '2212'  '2213'  '2214'  '4421'  '4422'  '4423'  '4424'  }, [-0.1 0.9], 'newname', 'epochs', 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, [] ,[]);
    EEG = pop_reref(EEG, []); % reference
    
%% rejection of bad segments using amplitude-based and joint probability artifact detection

    EEG = pop_eegthresh(EEG,1,[1:EEG.nbchan] ,[-250],[250],[EEG.xmin],[EEG.xmax],2,0); %you can change the threshold limits if too many epochs are rejected
    EEG = pop_jointprob(EEG,1,[1:EEG.nbchan],3,3,pipeline_visualizations_semiautomated,...
        0,pipeline_visualizations_semiautomated,[],pipeline_visualizations_semiautomated);

    EEG = eeg_rejsuperpose(EEG, 1, 0, 1, 1, 1, 1, 1, 1);
    EEG = pop_rejepoch(EEG, [EEG.reject.rejglobal] ,0);
    
    %     % identify and remove bad channels X2
    EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',2.5,'norm','on','measure','prob');
    EEG = pop_reref(EEG, []);
    EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',2.5,'norm','on','measure','kurt');
    EEG = pop_reref(EEG, []); 
    EEG = eeg_checkset( EEG );
    
    %%%  Run ICA using SOBI blind source component identification (good for
    %%%  sparse data)  then use ICLabel to automatically find and remove
    %%%  noise components, done twice
    EEG = pop_runica(EEG, 'icatype', 'sobi', 'dataset',1, 'options',{})
    EEG = iclabel(EEG, []);
    EEG = pop_icflag(EEG, [NaN NaN;0.6 1;0.6 1;NaN NaN;NaN NaN;0.6 1;NaN NaN]);
    EEG = pop_subcomp(EEG, [], 0);  
    EEG = pop_reref(EEG, []);
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'icatype', 'sobi', 'dataset',1, 'options',{})
    EEG = iclabel(EEG, []);
    EEG = pop_icflag(EEG, [NaN NaN;0.6 1;0.6 1;NaN NaN;NaN NaN;0.6 1;NaN NaN]);
    EEG = pop_subcomp(EEG, [], 0); 
    EEG = pop_reref(EEG, []);
    EEG = eeg_checkset( EEG );
    EEG.setname='Epoch';
    EEG = pop_saveset(EEG, 'filename',strrep(FileNames{current_file},'.edf', '_WL_Ep.set'),'filepath',src_folder_name) % to extract power density values.. save with original name and new extension in original folder
%%%%%%%% Turn the file back to a continuous dataset for use in BCILAB
    EEG = pop_epoch2continuous(EEG, 'warning', 'off');%% a great function from ERPLAB to sew the epochs back together so data can be used in bcilab
    EEG.setname='CT';
    EEG = pop_selectevent( EEG, 'type',{'boundary'},'renametype','''01''','deleteevents','off');
    EEG = pop_saveset(EEG, 'filename',strrep(FileNames{current_file},'.edf', '_WL_CT.set'),'filepath',src_folder_name) % to use in BCIlab... save with original name and new extension in original folder
end

%%% two short scripts to create the Low and High WL sets for use in
%%% extracting the power density from each frequency range in Darbelaia

% set the filenames for the looping through the folder
src_file_ext2 = 'Ep.set'
FileNames2=dir(['*' src_file_ext2]);
FileNames2={FileNames2.name};
% set the variable names used below
%% load the files in the folder set above one by one and conduct the spec function for each channel individually

for current_file = 1:length(FileNames2)
    EEG = pop_loadset(FileNames2{current_file}); 
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',[2211 2213 2212 2214] ,'deleteevents','on');
    EEG.setname='Low';
    EEG = pop_saveset(EEG, 'filename',strrep(FileNames2{current_file},'Ep.set', 'WL_LOW.set'),'filepath',src_folder_name)% make a new folder for the split WL files
end
eeglab redraw
for current_file = 1:length(FileNames2)
    EEG = pop_loadset(FileNames2{current_file}); 
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',[4421 4423 4422 4424] ,'deleteevents','on');  
    EEG.setname='High';
    EEG = pop_saveset(EEG, 'filename',strrep(FileNames2{current_file},'Ep.set', 'WL_HIGH.set'),'filepath',src_folder_name) 
end  % temp removed s13. maybe they have no triggers due to performance.. 


display('!!!!!!!!!!!!!!!!!')
display('PIPELINE COMPLETE')
display('!!!!!!!!!!!!!!!!!')