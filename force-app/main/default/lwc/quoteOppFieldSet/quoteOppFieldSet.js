import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getFieldSetFields from '@salesforce/apex/QuoteFieldSetController.getFieldSetFields';
import updateQuoteFields from '@salesforce/apex/QuoteFieldSetController.updateQuoteFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';


export default class QuoteOppFieldSet extends NavigationMixin(LightningElement) {
    
    @track fieldsWithValues = []; // Tracks fields with API name, label, and values
    @track error;
    @track fieldsWithValuesforload = [];
    recordExist;
    wireRecordId; //this will hold the current record id fetched from pagereference

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('currentPageReference ', currentPageReference);
            //it gets executed before the connected callback and avilable to use
            this.wireRecordId = currentPageReference.state.recordId;
        }
    } 

    connectedCallback() {
        // available in connected callback
        this.recordId = this.wireRecordId;
        if(this.recordId){
            this.loadFields();
        }
    }
    
    loadFields() {
        alert('123'); 
        
        getFieldSetFields({ fieldSetName: 'Approval_Fields',recordId:this.recordId})
            .then((result) => {
                // Precompute fields for template use
                this.fieldsWithValues = result
                .filter(field => !field.value) // Only include fields with blank values
                .map(field => ({
                    label: field.label,
                    apiName: field.apiName,
                    value: field.value || '', // Default to an empty string if value is null or undefined
                    isRequired: true // All displayed fields are required
                }));
                this.recordExist = this.fieldsWithValues.length > 0;
                this.error = null;
            })
            .catch((error) => {
                this.error = error.body.message;
                this.fieldsWithValues = [];
            });
    }

    
    handleFieldChange(event) {
        const { name, value } = event.target;
        // Update the value and required status in the corresponding field
        this.fieldsWithValues = this.fieldsWithValues.map((field) => {
            if (field.apiName === name) {
                return { ...field, value, isRequired: !value };
            }
            return field;
        });
    }

    handleSave() {
        if (!this.recordExist) {
            // If no blank fields, directly redirect to the VF page
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/apex/SubmitQuote?id=' + this.recordId
                }
            });
            return;
        }
        // Validate all required fields
        const allInputsValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((valid, input) => valid && input.checkValidity(), true);
    
        if (!allInputsValid) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please fill out all required fields.',
                    variant: 'error',
                })
            );
            return;
        }
    
        // Convert fieldsWithValues to a map of API names and values
        const fieldValues = this.fieldsWithValues.reduce((quote, field) => {
            quote[field.apiName] = field.value;
            return quote;
        }, {});
    
        updateQuoteFields({ quoteId: this.recordId, fieldValues  })
            .then(() => {
                this.error = null;
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Success',
                //         message: 'Quote updated successfully',
                //         variant: 'success',
                //     })
                // );
                
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: '/apex/SubmitQuote?id='+ this.recordId
                    }
                });
                
            })
            .catch((error) => {
                this.error = error.body.message;
            });
        }

    
}