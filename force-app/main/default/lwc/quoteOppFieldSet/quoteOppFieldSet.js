import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuoteFieldDetails from '@salesforce/apex/QuoteFieldUpdateController.getQuoteFieldDetails';
import updateQuoteFields from '@salesforce/apex/QuoteFieldUpdateController.updateQuoteFields';

export default class QuoteOppFieldSet extends LightningElement {
    @api recordId;
    
    // Field set name - REPLACE WITH YOUR ACTUAL FIELD SET NAME
    fieldSetName = 'YourFieldSetName';
    
    @track fields = [];
    @track fieldValues = {};
    @track isLoading = false;

    // Lifecycle hook to load field details
    connectedCallback() {
        this.loadQuoteFieldDetails();
    }

    // Load quote field details from field set
    async loadQuoteFieldDetails() {
        this.isLoading = true;
        try {
            const result = await getQuoteFieldDetails({
                quoteId: this.recordId, 
                fieldSetName: this.fieldSetName
            });

            // Prepare fields and their current values
            this.fields = result.fields;
            this.fieldValues = result.values;
        } catch (error) {
            this.showToast('Error', 'Failed to load field details', 'error');
            console.error('Load Error:', error);
        } finally {
            this.isLoading = false;
        }
    }

    // Handle input changes
    handleFieldChange(event) {
        const fieldName = event.target.dataset.field;
        const value = event.target.value;
        
        // Update field values
        this.fieldValues[fieldName] = value;
    }

    // Handle field update
    async handleUpdateFields() {
        this.isLoading = true;
        
        try {
            // Prepare fields to update (only non-blank values)
            const fieldsToUpdate = {};
            for (const field of this.fields) {
                const value = this.fieldValues[field.apiName];
                if (value !== undefined && value !== null && value !== '') {
                    fieldsToUpdate[field.apiName] = value;
                }
            }

            // Call Apex method to update fields
            await updateQuoteFields({
                quoteId: this.recordId,
                fieldSetName: this.fieldSetName,
                fieldValues: fieldsToUpdate
            });

            // Show success toast
            this.showToast('Success', 'Fields updated successfully', 'success');

            // Refresh the view
            this.dispatchEvent(new CustomEvent('refreshview'));
        } catch (error) {
            this.showToast('Error', error.body ? error.body.message : 'An unexpected error occurred', 'error');
            console.error('Update Error:', error);
        } finally {
            this.isLoading = false;
        }
    }

    // Utility method to show toast notifications
    showToast(title, message, variant) {
        const toast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toast);
    }   
}