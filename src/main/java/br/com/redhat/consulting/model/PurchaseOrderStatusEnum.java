package br.com.redhat.consulting.model;

public enum PurchaseOrderStatusEnum {

    IN_PROGRESS  (1, "In progress"),
    CREATED     (2, "Created"),
    FINISHED     (3, "Finished");
    
    private int id;
    private String description;
    
    private PurchaseOrderStatusEnum(int id, String description) {
        this.id = id;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }
    
    public static PurchaseOrderStatusEnum find(int _id) {
    	PurchaseOrderStatusEnum[] sts = values();
        for (int i = 0; i < sts.length; i++) {
            if (_id == sts[i].getId())
                return sts[i];
        }
        return null;
    }

}
