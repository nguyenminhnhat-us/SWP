package dal;



import java.time.LocalDate;

public class CareOrderDay {
    private int id;
    private int careOrderId;
    private LocalDate careDate;

    public CareOrderDay() {}

    public CareOrderDay(int careOrderId, LocalDate careDate) {
        this.careOrderId = careOrderId;
        this.careDate = careDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCareOrderId() {
        return careOrderId;
    }

    public void setCareOrderId(int careOrderId) {
        this.careOrderId = careOrderId;
    }

    public LocalDate getCareDate() {
        return careDate;
    }

    public void setCareDate(LocalDate careDate) {
        this.careDate = careDate;
    }
}
