' Functions to handle event processing 
' for the roku channel


Function enterEventLoop( port as Object)
    while true
        msg = wait(0, port)
        if type(msg) = "roGridScreenEvent" then
        	leaveLoop = processGridEvent(msg)
        	if leaveLoop = true then 
        		return -1
            endif
        elseif type(msg) = "roPosterScreenEvent" then
        	leaveLoop = processPosterEvent(msg)
        	if leaveLoop = true then 
        		return -1
            endif
        elseif type(msg) = "roSpringboardScreenEvent" then
        	leaveLoop = processSpringboardEvent(msg)
        	if leaveLoop = true then 
        		return -1
            endif
        elseif type(msg) = "roVideoScreenEvent"
            leaveLoop = processScreenEvent(msg)
            if leaveLoop = true then
            	return -1
            endif
        elseif type(msg) = "Invalid" then
            print "invalid message, closing down"
            exit while
        endif
     end while
End Function 

Function processGridEvent( msg as Object)
    if msg.isScreenClosed() then
    	print "Grid Screen Closed. Exiting."
        return true
    elseif msg.isListItemFocused()
        print "Focused msg: ";msg.GetMessage();"row: ";msg.GetIndex();
        print " col: ";msg.GetData()
    elseif msg.isListItemSelected()
        print "Selected msg: ";msg.GetMessage();"row: ";msg.GetIndex();
        print " col: ";msg.GetData()
        displayPosterScreen()
    endif
End Function 

Function processPosterEvent( msg as Object)
    if msg.isScreenClosed() then
    	print "Poster Screen Closed. Exiting."
        return true
    elseif msg.isButtonPressed()
        print "msg: ";msg.GetMessage();"idx: ";msg.GetIndex()
    elseif msg.isListItemSelected()
        print "msg: ";msg.GetMessage();"idx: ";msg.GetIndex()
        displaySpringboardScreen()
    endif
End Function 

Function processSpringboardEvent( msg as Object)
    if msg.isScreenClosed() then
    	print "Springboard Screen Closed. Exiting."
        return true
    elseif msg.isButtonPressed() 
        print "msg: "; msg.GetMessage(); "idx: "; msg.GetIndex()
        if msg.GetIndex() = 1
            displayVideo()
        else if msg.GetIndex() = 2
            print "go back"
            return true
        endif
    endif
End Function 

Function processScreenEvent( msg as Object )
    if msg.isScreenClosed() then 'ScreenClosed event
        print "Closing video screen"
        return true
    else if msg.isRequestFailed()
        print "play failed: "; msg.GetMessage()
    else
        print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
    endif
End Function
