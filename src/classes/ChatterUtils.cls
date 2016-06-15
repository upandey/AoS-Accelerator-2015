public with sharing class ChatterUtils {
   
  
  // makes a simple chatter text post to the specified user from the running user 
  public static void mentionTextPost(Id postRecordId, Id userToMentionId, String postText) { 
    
    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
    // add some text before the mention
    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = 'Hey ';
    messageInput.messageSegments.add(textSegment);
    
    // add the mention
    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
    mentionSegment.id = userToMentionId;
    messageInput.messageSegments.add(mentionSegment);
    
    // add the text that was passed
    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = postText;
    messageInput.messageSegments.add(textSegment);
    
    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
    input.body = messageInput;
    input.subjectId = postRecordId;
    // post it
    //ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.UserProfile, userId, input, null);
      ConnectApi.ChatterFeeds.postFeedElement(null, input, null);
  }     
  
       

}