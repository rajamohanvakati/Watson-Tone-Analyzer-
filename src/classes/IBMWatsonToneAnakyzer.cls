public class IBMWatsonToneAnakyzer {
    
    Private String caseId {get;set;}
    public Case c{get;set;}
    public String jsonData{get;set;}
    public ToneAnalysis tones {get;set;}
    public IBMWatsonToneAnakyzer(ApexPages.StandardController con){
        caseId = con.getId() ; 
        c =[Select Id , Subject,Description from Case where id=:caseId] ;
        callWatsonToneAnalyser(c);
    }
    
    public  void callWatsonToneAnalyser(Case c) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Bluemix_Tone_Analyser/v3/tone?version=2016-05-18');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(stringToJSON(c));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        jsonData = res.getBody();
        tones =  (ToneAnalysis) JSON.deserialize(res.getBody(), ToneAnalysis.class);
    }
    
    private static String stringToJSON(Case c) {
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        generator.writeStringField('text', c.Subject+''+c.Description);
        generator.writeEndObject();
        return generator.getAsString();
    }
    public Class ToneAnalysis {
        public DocumentTone document_tone {get; set;} 
    }
    
    public Class DocumentTone {
        public  List<ToneCategory> tone_categories {get; set;}
    }
    
    public Class ToneCategory {
        public  List<Tone> tones {get; set;}
        public  String category_id {get; set;}
        public  String category_name {get; set;}
    }
    
    public Class Tone {
        public  Double  score {get; set;}
        public  String tone_id {get; set;}
        public  String tone_name {get; set;}
    }
    
}