function [ ] = enableLineScrolling(textFieldHandle)
% enableLineScrolling
% for a multi-line editable text field, the default is that the user can't
% move over to see the end of a long line. This fixes that.



jHandle = findjobj(textFieldHandle);
jHandle.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR))

jViewPort = jHandle.getViewport;
jEditbox = jViewPort.getComponent(0);
jEditbox.setWrapping(false);  % do *NOT* use set(...)!!!
%newPolicy = jHandle.HORIZONTAL_SCROLLBAR_AS_NEEDED;
%set(jHandle,'HorizontalScrollBarPolicy',newPolicy);

end

