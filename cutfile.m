 function isOk = cutfile( fileLocator, nLines )
    isOk = true ;
    % - Split input file name, read file.
    [path_in,fname_in,ext_in] = fileparts( fileLocator ) ;
    buffer = fileread( fileLocator ) ;
    % - Find lines ends (must check wheter file ends with one and remove 
    %   it from the list if present).
    lineEnds = find( buffer == 10 ) ;
    if buffer(end) == 10 || buffer(end-1) == 10
       lineEnds(end) = [] ;
    end
    % - Check not case where more lines to remove than present in file.
    if numel(lineEnds)-nLines < 1
       fprintf( 'Skip removing %d lines, file contains only %d lines.\n', ...
                nLines, numel(lineEnds) ) ;
       isOk = false ;
       return ;
    end
    % - Compute cutoff position in buffer.
    cutoff = lineEnds(end-nLines+1)-1 ;
    % - Build new file name.
    fname_out = sprintf( '%s_%d.%s', fname_in, nLines, ext_in ) ;
    % - Output to file.
    fid = fopen( fullfile( path_in, fname_out ), 'w' ) ;
    fwrite( fid, buffer(1:cutoff) ) ;
    fclose( fid ) ;
 end