"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import apiClient from "@/lib/api-client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { Plus, Pencil, KeyRound } from "lucide-react";

export default function ChefsPage() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingChef, setEditingChef] = useState<any>(null);
  const [resetPinId, setResetPinId] = useState<string | null>(null);
  const [newPin, setNewPin] = useState("");
  const [form, setForm] = useState({ name: "", phoneNumber: "", email: "" });
  const queryClient = useQueryClient();

  const { data: chefs, isLoading } = useQuery({
    queryKey: ["chefs"],
    queryFn: async () => {
      const res = await apiClient.get("/admin/chefs");
      return res.data.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: async (data: typeof form) => {
      await apiClient.post("/admin/chefs", data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["chefs"] });
      toast.success("Chef created");
      setDialogOpen(false);
      setForm({ name: "", phoneNumber: "", email: "" });
    },
    onError: () => toast.error("Failed to create chef"),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: string; data: typeof form }) => {
      await apiClient.patch(`/admin/chefs/${id}`, data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["chefs"] });
      toast.success("Chef updated");
      setDialogOpen(false);
      setEditingChef(null);
      setForm({ name: "", phoneNumber: "", email: "" });
    },
    onError: () => toast.error("Failed to update chef"),
  });

  const resetPinMutation = useMutation({
    mutationFn: async ({ id, pin }: { id: string; pin: string }) => {
      await apiClient.patch(`/admin/chefs/${id}/reset-pin`, { pin });
    },
    onSuccess: () => {
      toast.success("PIN reset successfully");
      setResetPinId(null);
      setNewPin("");
    },
    onError: () => toast.error("Failed to reset PIN"),
  });

  const openEdit = (chef: any) => {
    setEditingChef(chef);
    setForm({ name: chef.name, phoneNumber: chef.phoneNumber, email: chef.email || "" });
    setDialogOpen(true);
  };

  const handleSubmit = () => {
    if (editingChef) {
      updateMutation.mutate({ id: editingChef.id, data: form });
    } else {
      createMutation.mutate(form);
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Chefs Management</CardTitle>
          <Button onClick={() => { setEditingChef(null); setForm({ name: "", phoneNumber: "", email: "" }); setDialogOpen(true); }}>
            <Plus className="mr-2 h-4 w-4" />
            Add Chef
          </Button>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Name</TableHead>
                  <TableHead>Phone</TableHead>
                  <TableHead>Orders Today</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="w-24">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                  [...Array(5)].map((_, i) => (
                    <TableRow key={i}>
                      {[...Array(5)].map((_, j) => (
                        <TableCell key={j}>
                          <div className="h-4 w-full animate-pulse rounded bg-muted" />
                        </TableCell>
                      ))}
                    </TableRow>
                  ))
                ) : chefs?.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center text-muted-foreground">
                      No chefs found
                    </TableCell>
                  </TableRow>
                ) : (
                  chefs?.map((chef: any) => (
                    <TableRow key={chef.id}>
                      <TableCell className="font-medium">{chef.name}</TableCell>
                      <TableCell>{chef.phoneNumber}</TableCell>
                      <TableCell>{chef.ordersToday ?? 0}</TableCell>
                      <TableCell>
                        <Badge variant={chef.isActive ? "default" : "secondary"}>
                          {chef.isActive ? "Active" : "Inactive"}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="flex gap-1">
                          <Button variant="ghost" size="icon" onClick={() => openEdit(chef)}>
                            <Pencil className="h-4 w-4" />
                          </Button>
                          <Button variant="ghost" size="icon" onClick={() => setResetPinId(chef.id)}>
                            <KeyRound className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      {/* Add/Edit Dialog */}
      <Dialog open={dialogOpen} onOpenChange={(open) => { if (!open) setDialogOpen(false); }}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>{editingChef ? "Edit Chef" : "Add Chef"}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>Name</Label>
              <Input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
            </div>
            <div className="space-y-2">
              <Label>Phone Number</Label>
              <Input value={form.phoneNumber} onChange={(e) => setForm({ ...form, phoneNumber: e.target.value })} />
            </div>
            <div className="space-y-2">
              <Label>Email (optional)</Label>
              <Input value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Cancel</Button>
            <Button onClick={handleSubmit} disabled={createMutation.isPending || updateMutation.isPending}>
              {editingChef ? "Save Changes" : "Create"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Reset PIN Dialog */}
      <Dialog open={!!resetPinId} onOpenChange={() => { setResetPinId(null); setNewPin(""); }}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>Reset Chef PIN</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>New PIN (4 digits)</Label>
              <Input
                maxLength={4}
                value={newPin}
                onChange={(e) => setNewPin(e.target.value.replace(/\D/g, ""))}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setResetPinId(null); setNewPin(""); }}>Cancel</Button>
            <Button
              onClick={() => resetPinId && resetPinMutation.mutate({ id: resetPinId, pin: newPin })}
              disabled={newPin.length !== 4 || resetPinMutation.isPending}
            >
              Reset PIN
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
