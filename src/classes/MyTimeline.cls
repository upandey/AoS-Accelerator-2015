global class MyTimeline{

    global class Era {
    }

    global class MyDate {
        global String startDate;
        global String endDate;
        global String headline;
        global String text;
        global String tag;
        global String classname;
    }

    global Timeline timeline;

    global class Timeline {
        global String headline;
        global String type;
        global String text;
        global List<MyDate> mydate;
        global List<Era> era;
    }

    
    global static MyTimeline parse(String json) {
        return (MyTimeline) System.JSON.deserialize(json, MyTimeline.class);
    }
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"timeline\":'+
        '    {'+
        '        \"headline\":\"Timeline for Case #012332\",'+
        '        \"type\":\"default\",'+
        '        \"text\":\"<p>Intro body text goes here, some HTML is ok</p>\",'+
        '        \"mydate\": ['+
        '            {'+
        '                \"startDate\":\"2015,8,25\",'+
        '                \"endDate\":\"2015,8,28\",'+
        '                \"headline\":\"Initial Outreach\",'+
        '                \"text\":\"<p>Temperature fluctuations detected!</p><p>Communication sent to United Oil and Gas with relevant self-help guide</p>\",'+
        '                \"tag\":\"Communication\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        ''+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,8,29\",'+
        '                \"endDate\":\"2015,8,29\",'+
        '                \"headline\":\"Case created\",'+
        '                \"text\":\"<p>Device constantly restarting due to rise in unit temperature<p>\",'+
        '                \"tag\":\"Activity\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,8,30\",'+
        '                \"endDate\":\"2015,8,30\",'+
        '                \"headline\":\"Appointment E-mail\",'+
        '                \"text\":\"<p>Appointment times sent to customer</p>\",'+
        '                \"tag\":\"Communication\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,9,1\",'+
        '                \"endDate\":\"2015,9,1\",'+
        '                \"headline\":\"Appointment created\",'+
        '                \"text\":\"<p>An appointment has been scheduled for 4th September, 2015 (4 pm EST)</p>\",'+
        '                \"tag\":\"Activity\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,9,4\",'+
        '                \"endDate\":\"2015,9,4\",'+
        '                \"headline\":\"Service Event\",'+
        '                \"text\":\"<p>In Progress</p>\",'+
        '                \"tag\":\"Activity\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,9,4\",'+
        '                \"endDate\":\"2015,9,4\",'+
        '                \"headline\":\"Case Closed\",'+
        '                \"text\":\"<p>Service issue resolved and tempature readings are within normal range</p>\",'+
        '                \"tag\":\"Activity\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            },'+
        '            {'+
        '                \"startDate\":\"2015,9,5\",'+
        '                \"endDate\":\"2015,9,5\",'+
        '                \"headline\":\"Post-Case Feedback\",'+
        '                \"text\":\"<p>Survey e-mail sent across to customer</p>\",'+
        '                \"tag\":\"Communication\",'+
        '                \"classname\":\"optionaluniqueclassnamecanbeaddedhere\"'+
        '            }'+
        '        ],'+
        '        \"era\": ['+
        '        ]'+
        '    }'+
        '}';
        MyTimeline obj = parse(json);
        System.assert(obj != null); 
    }
}