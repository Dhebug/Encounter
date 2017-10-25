
function [animatory_states,tileset]=generaCostObject(path,costid)

tileset(1).data=[0 0 0 0 0 0 0 0];
tileset(1).mask=[255 255 255 255 255 255 255 255];
animatory_states(1).data=[];
animatory_states(1).datainv=[];
kk=dir(strcat(path,'\','*.png'));
graphic=[];
for as=0:(length(kk)-1)
    imname=(kk(as+1).name);
    im=imread(strcat(path,'\',imname));
    im=rgb2gray(im);
    graphic=im>0; 
    mask=im==150;
    graphic=(graphic) & not(mask);

    for rows=1:size(graphic,1)/8
        for cols=1:size(graphic,2)/6
            for scan=1:8
                temp(scan)= graphic(scan+(rows-1)*8,1+(cols-1)*6)*2^5+graphic(scan+(rows-1)*8,2+(cols-1)*6)*2^4+graphic(scan+(rows-1)*8,3+(cols-1)*6)*2^3+graphic(scan+(rows-1)*8,4+(cols-1)*6)*2^2+graphic(scan+(rows-1)*8,5+(cols-1)*6)*2+graphic(scan+(rows-1)*8,6+(cols-1)*6);
                tempm(scan)=mask(scan+(rows-1)*8,1+(cols-1)*6)*2^5+   mask(scan+(rows-1)*8,2+(cols-1)*6)*2^4+   mask(scan+(rows-1)*8,3+(cols-1)*6)*2^3+   mask(scan+(rows-1)*8,4+(cols-1)*6)*2^2+   mask(scan+(rows-1)*8,5+(cols-1)*6)*2+   mask(scan+(rows-1)*8,6+(cols-1)*6);
                tempm(scan)=tempm(scan)+64;%192;
                if(tempm(scan)==127) 
                    tempm(scan)=255;
                end
             end
            [index,tileset]=busca_tile(temp,tempm,tileset);
            temp=[];tempm=[];
            animatory_states(as+1).data(rows,cols)=index;
        end
    end
 
end

genera_datos(tileset,animatory_states,kk, graphic, path, costid);

end


function [index,tileset]=busca_tile(tile,tilem,tileset)

     for k=1:length(tileset)
        if(all(tileset(k).data==tile) && all(tileset(k).mask==tilem))
            break; 
        end;
    end
            
    if(not(all(tileset(k).data==tile) && all(tileset(k).mask==tilem)))
        k=k+1;
        tileset(k).data=tile;
        tileset(k).mask=tilem;
    end
    index=k;
end
    

function genera_datos(tileset,animatory_states, kk, graphic, carpeta, costid)
fid=fopen(strcat(carpeta,'\cost_res.s'),'w');

fprintf(fid,'.(\n.byt RESOURCE_COSTUME\n.word (res_end - res_start + 4)\n');
fprintf(fid,'.byt %d\n',costid);
fprintf(fid,'res_start\n\t; Pointers to tiles\n\t.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)\n\t.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)\n');
fprintf(fid,'\t; Number of costumes included\n\t.byt 1\n\t;Offsets to animatory states for each costume\n\t.byt <(anim_states - res_start), >(anim_states - res_start)\n');

fprintf(fid,'anim_states\n');
for i=1:length(animatory_states)
        fprintf(fid,'; Animatory state %d (%s)\n',i-1,kk(i).name);
        fprintf(fid,'.byt ');
        irow=7-size(graphic,1)/8;
        for k1=1:7
         for k2=1:5
             if (k1<=irow) || (k2>size(graphic,2)/6) 
                 fprintf(fid,'0');
             else
                fprintf(fid,'%d',animatory_states(i).data(k1-irow,k2)-1);
             end
             
             if(k2<5)
                fprintf(fid,', ');
             end
         end
         fprintf(fid,'\n');
         if(k1<7)
            fprintf(fid,'.byt ');
         end
        end
end

fprintf(fid,'costume_tiles\n');
for i=2:length(tileset)
    fprintf(fid,'; Tile graphic %d\n',i-1);
    fprintf(fid,'.byt ');
    for k=1:8
        fprintf(fid,'$%x',tileset(i).data(k));
        if(k<8)
            fprintf(fid,', ');
        end
    end
    fprintf(fid,'\n');
end

fprintf(fid,'costume_masks\n');
for i=2:length(tileset)
    fprintf(fid,'; Tile mask %d\n',i-1);
    fprintf(fid,'.byt ');
    for k=1:8
        fprintf(fid,'$%x',tileset(i).mask(k));
        if(k<8)
            fprintf(fid,', ');
        end
    end
    fprintf(fid,'\n');
end



fprintf(fid,'res_end\n.)\n\n');
fclose(fid);
end

