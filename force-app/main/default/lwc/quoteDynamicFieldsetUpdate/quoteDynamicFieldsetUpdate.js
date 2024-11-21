import { LightningElement, api, track } from 'lwc';
import getFieldSetFields from '@salesforce/apex/QuoteFieldSetController.getFieldSetFields';
import updateQuoteFields from '@salesforce/apex/QuoteFieldSetController.updateQuoteFields';

export default class QuoteDynamicFieldsetUpdate extends LightningElement {
    @api recordId; // Quote record ID
    @track fieldsWithValues = []; // Tracks fields with API name, label, and values
    @track error;

    connectedCallback() {
        this.loadFields();
    }

    loadFields() {
        alert(this.recordId);
        getFieldSetFields({ fieldSetName: 'Approval_Fields' })
            .then((result) => {
                // Precompute fields for template use
                this.fieldsWithValues = result.map((fieldApiName) => ({
                    apiName: fieldApiName,
                    label: fieldApiName, // Replace with a label mapping if needed
                    value: '' // Initialize with blank values
                }));
                this.error = null;
                alert(JSON.stringify(this.fieldsWithValues));
            })
            .catch((error) => {
                this.error = error.body.message;
                this.fieldsWithValues = [];
            });
    }

    handleFieldChange(event) {
        const { name, value } = event.target;
        // Update the value in the corresponding field
        this.fieldsWithValues = this.fieldsWithValues.map((field) => {
            if (field.apiName === name) {
                return { ...field, value };
            }
            return field;
        });
    }

    handleSave() {
        // Convert fieldsWithValues to a map of API names and values
        const fieldValues = this.fieldsWithValues.reduce((acc, field) => {
            acc[field.apiName] = field.value;
            return acc;
        }, {});

        updateQuoteFields({ 
            quoteId: this.recordId, 
            fieldValues 
        })
            .then(() => {
                this.error = null;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Quote updated successfully',
                        variant: 'success',
                    })
                );
            })
            .catch((error) => {
                this.error = error.body.message;
            });
    }
}