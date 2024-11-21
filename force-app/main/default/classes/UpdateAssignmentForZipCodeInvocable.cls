public class UpdateAssignmentForZipCodeInvocable {
    public class GetVariables{
        @InvocableVariable(label = 'SDRorBDRorAE' required = true)
        public String sDRorBDRorAE;
        
        @InvocableVariable(label = 'oldAssignment' required = true)
        public Id oldAssignment;
        
        @InvocableVariable(label = 'newAssignment' required = true)
        public Id newAssignment;
    }
    @InvocableMethod(label = 'Update Assignment From Screen Flow')
    public static void getZipCodeRecords(List<GetVariables> getVariables){
    //    System.debug('Get Variables: ' + getVariables);
        GetVariables var = getVariables[0];
   //     System.debug('Var: ' + var);
        List<String> resultMsg = new List<String>();
        UpdateAssignmentForZipCodeBatch objBatch = new UpdateAssignmentForZipCodeBatch(var.sDRorBDRorAE, var.oldAssignment, var.newAssignment);
        Id batchId = Database.executeBatch(objBatch, 1000);
    }

}