function uuidString = generateUUID()
%generateUUID
% generates a random UUID string that each metadata object will have. This
% UUID will be used to keep locations, sessions, etc. straight, even when
% numbering is edited.

uuidString = char(java.util.UUID.randomUUID().toString());

end

