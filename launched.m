function launched()

user  = 'maarten.haneveer@gmail.com';
pass  = 'maartenhaneveer1990';
URL='https://www.space-track.org/ajaxauth/login';

    post={...
      'identity',user,...
      'password',pass,...
      'query',[...
        'https://www.space-track.org/basicspacedata/',...
        'query/class/satcat/' ...
        'LAUNCH/>now-30/CURRENT/Y/orderby/'...
        'LAUNCH DESC/format/html',...
      ]...
    };

    out=urlread(URL,'Post',post,'Timeout',10);
    
    txt = regexprep(out,'<script.*?/script>','\t');
    txt = regexprep(txt,'<style.*?/style>','\t');
    txt = regexprep(txt,'<.*?>','\t');
    
    fid=fopen('launched.txt','w+');
    fprintf(fid,'%s',txt);
    fclose(fid);   
    
uiimport('launched.txt')

%https://www.space-track.org/basicspacedata/query/class/satcat/
%LAUNCH/>now-7/CURRENT/Y/orderby/LAUNCH DESC/format/html