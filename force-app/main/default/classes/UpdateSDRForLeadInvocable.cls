public class UpdateSDRForLeadInvocable {
    public class GetVariables{
        
		@InvocableVariable(label = 'SDRorBDRorAE' required = true)
        public String sDRorBDRorAE;
        
        @InvocableVariable(label = 'oldAssignment' required = true)
        public Id oldAssignment;
        
        @InvocableVariable(label = 'newAssignment' required = true)
        public Id newAssignment;
    }
    
    @InvocableMethod(label = 'Update SDR From Screen Flow')
    public static void getLeadRecords(List<GetVariables> getVariables){

        System.debug('Get Variables: ' + getVariables);
        GetVariables var = getVariables[0];
        List<String> resultMsg = new List<String>();
        UpdateSDRForLeadBatch objBatch = new UpdateSDRForLeadBatch(var.sDRorBDRorAE, var.oldAssignment, var.newAssignment);
        Id batchId = Database.executeBatch(objBatch, 1000);
    }
}