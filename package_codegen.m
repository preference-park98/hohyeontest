
#define hello

#ifdef hello
#endif

function package_codegen(modelName, versionTag)
if nargin < 1, modelName = 'jetRacer'; end
if nargin < 2, versionTag = datestr(now,'yyyymmdd_HHMMSS'); end

codeDir = fullfile(pwd, [modelName '_ert_rtw']);
if ~isfolder(codeDir)
    error("코드 폴더가 없습니다: %s (먼저 build 하세요)", codeDir);
end

outRoot = fullfile(pwd, 'releases', versionTag);
outSrc  = fullfile(outRoot, 'src');
outInfo = fullfile(outRoot, 'info');
if ~isfolder(outSrc),  mkdir(outSrc);  end
if ~isfolder(outInfo), mkdir(outInfo); end

#안녕하세요 무야호

keep = {
    [modelName '.cpp']
    [modelName '.h']
    [modelName '_data.cpp']
    [modelName '_private.h']
    [modelName '_types.h']
    'rtwtypes.h'
    'ert_main.cpp'
    };

copied = {};
for i=1:numel(keep)
    f = fullfile(codeDir, keep{i});
    if isfile(f)
        copyfile(f, outSrc);
        copied{end+1} = keep{i}; %#ok<AGROW>
    end
end

infoTxt = fullfile(outInfo, 'build_info.txt');
fid = fopen(infoTxt,'w');
fprintf(fid, "model: %s\n", modelName);
fprintf(fid, "versionTag: %s\n", versionTag);
fprintf(fid, "timestamp: %s\n", datestr(now));
fprintf(fid, "source_code_dir: %s\n", codeDir);
fprintf(fid, "copied_files:\n");
for i=1:numel(copied), fprintf(fid, " - %s\n", copied{i}); end
fclose(fid);

zipFile = fullfile(pwd, 'releases', [versionTag '.zip']);
zip(zipFile, outRoot);

fprintf("OK: %s\n", outRoot);
fprintf("ZIP: %s\n", zipFile);
end


